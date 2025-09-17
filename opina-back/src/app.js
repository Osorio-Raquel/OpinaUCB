import express from 'express';
import morgan from 'morgan';
import helmet from 'helmet';
import cors from 'cors';
import rateLimit from 'express-rate-limit';
import 'dotenv/config';

import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

import { fileURLToPath } from 'url';
import path from 'path';

// Rutas
import authRoutes from '../routes/auth.routes.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

/** 🔑 Estás detrás de proxy (ngrok) → habilita trust proxy ANTES del rate-limit */
app.set('trust proxy', 1); // o true

app.use(express.json());
app.use(morgan('dev'));

/** Helmet: deja lo básico; si sirves Swagger, evita romperlo */
app.use(helmet({
  crossOriginOpenerPolicy: { policy: 'same-origin-allow-popups' },
}));

/** CORS: autoriza tus orígenes (web). Flutter nativo no necesita CORS */
const allowed = (process.env.CORS_ORIGINS || '')
  .split(',')
  .map(s => s.trim())
  .filter(Boolean);

// Si no defines CORS_ORIGINS, permitimos todo (útil para dev)
app.use(cors(allowed.length
  ? { origin: (origin, cb) => (!origin || allowed.includes(origin)) ? cb(null, true) : cb(new Error('Origen no permitido')) }
  : { origin: true }
));

/** Rate limit (ya con IP correcta gracias a trust proxy) */
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 600,
  standardHeaders: 'draft-7',
  legacyHeaders: false,
});
app.use(limiter);

/** Healthcheck */
app.get('/api/health', (_req, res) =>
  res.json({ ok: true, time: new Date().toISOString() })
);

/** Rutas de app */
app.use('/auth', authRoutes);

/** Swagger */
const serverUrl = process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}`;
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: { title: 'API Opina', version: '1.0.0', description: 'Documentación de la API Opina' },
    components: {
      securitySchemes: { bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' } },
    },
    servers: [{ url: serverUrl }],
  },
  apis: [path.join(__dirname, '..', 'routes', '*.js')],
};
const swaggerSpec = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

/** Errores */
app.use((err, _req, res, _next) => {
  if (err && err.message === 'Origen no permitido') {
    return res.status(403).json({ ok: false, error: 'CORS: origen no permitido' });
  }
  console.error(err);
  res.status(500).json({ ok: false, error: 'Error interno del servidor' });
});

export { app };
