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
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

app.use(express.json());
app.use(morgan('dev'));
app.use(helmet());

// CORS con whitelist desde env (CORS_ORIGINS=URL1,URL2)
app.use(cors({
  origin: (origin, cb) => {
    const allowed = (process.env.CORS_ORIGINS || '')
      .split(',')
      .map(s => s.trim())
      .filter(Boolean);
    if (!origin || allowed.length === 0 || allowed.includes(origin)) {
      return cb(null, true);
    }
    cb(new Error('Origen no permitido'));
  }
}));

app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 600 }));

app.get('/api/health', (_req, res) =>
  res.json({ ok: true, time: new Date().toISOString() })
);

// ---------- Swagger ----------
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'API Opina',
      version: '1.0.0',
      description: 'Documentación de la API Opina con Swagger',
    },
    components: {
      securitySchemes: {
        bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
      },
    },
    servers: [
      { url: process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}` }
    ],
  },
  // Incluimos tu patrón EXACTO + la ruta absoluta por compatibilidad
  apis: [
    "./routes/*.js",                            // ← como pediste
    path.join(__dirname, 'routes', '*.js'),     // ← robusto en ESM
  ],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

export { app };
