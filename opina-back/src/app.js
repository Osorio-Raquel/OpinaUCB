import express from 'express';
import morgan from 'morgan';
import helmet from 'helmet';
import cors from 'cors';
import rateLimit from 'express-rate-limit';
import 'dotenv/config';

const app = express();
app.use(express.json());
app.use(morgan('dev'));
app.use(helmet());
app.use(cors({
  origin: (origin, cb) => {
    const allowed = (process.env.CORS_ORIGINS || '').split(',').filter(Boolean);
    if (!origin || allowed.length === 0 || allowed.includes(origin)) return cb(null, true);
    cb(new Error('Origen no permitido'));
  }
}));
app.use(rateLimit({ windowMs: 15*60*1000, max: 600 }));

app.get('/api/health', (_req, res) => res.json({ ok: true, time: new Date().toISOString() }));

export { app };

