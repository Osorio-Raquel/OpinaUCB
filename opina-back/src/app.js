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
import authRoutes from '../routes/auth.routes.js';
import surveyRoutes from '../routes/survey.routes.js'; // Resultado de las encuestas
import experienciaApoyoRoutes from '../routes/experienciaApoyo.routes.js';
import infraestructuraRoutes from '../routes/infraestructura.routes.js';
import calidadAcademicaRoutes from '../routes/calidadAcademica.routes.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

/** detrás de proxy (ngrok) */
app.set('trust proxy', 1);

app.use(express.json());
app.use(morgan('dev'));
app.use(helmet({
  crossOriginOpenerPolicy: { policy: 'same-origin-allow-popups' },
}));

/** ---------- CORS SOLO PARA NAVEGADOR ---------- */
const allowedList = (process.env.CORS_ORIGINS || '')
  .split(',')
  .map(s => s.trim())
  .filter(Boolean);

// Permitimos cualquier localhost:* (útil para web dev)
const allowLocalhost = /^http:\/\/localhost(?::\d+)?$/;

app.use(cors({
  origin: (origin, cb) => {
    // Llamadas sin Origin = apps nativas Flutter / curl -> OK
    if (!origin) return cb(null, true);

    // localhost:any -> OK
    if (allowLocalhost.test(origin)) return cb(null, true);

    // Si el origin está en la lista (por ej. ngrok) -> OK
    if (allowedList.includes(origin)) return cb(null, true);

    return cb(new Error('Origen no permitido'));
  },
  credentials: true,
}));

/** rate-limit */
app.use(rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 600,
  standardHeaders: 'draft-7',
  legacyHeaders: false,
}));

/** health */
app.get('/api/health', (_req, res) => {
  res.json({ ok: true, time: new Date().toISOString() });
});

/** rutas */
app.use('/auth', authRoutes);
app.use('/api/surveys', surveyRoutes); // Rutas de obtener encuestas
app.use('/experiencia-apoyo', experienciaApoyoRoutes);
app.use('/infraestructura-servicios', infraestructuraRoutes);
app.use('/calidad-academica', calidadAcademicaRoutes);
/** ---------- Swagger: lista localhost y, si existe, NGROK_URL ---------- */
const port = process.env.PORT || 3000;
const servers = [
  { url: `http://localhost:${port}` },
];
if (process.env.NGROK_URL) {
  servers.push({ url: process.env.NGROK_URL });
}

const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: { title: 'API Opina', version: '1.0.0', description: 'Documentación de la API Opina' },
    components: { securitySchemes: { bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' } } },
    servers,
  },
  apis: [path.join(__dirname, '..', 'routes', '*.js')],
};
const swaggerSpec = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

/** errores */
app.use((err, _req, res, _next) => {
  if (err?.message === 'Origen no permitido') {
    return res.status(403).json({ ok: false, error: 'CORS: origen no permitido' });
  }
  console.error(err);
  res.status(500).json({ ok: false, error: 'Error interno del servidor' });
});

export { app };
