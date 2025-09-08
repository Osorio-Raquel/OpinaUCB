import express from 'express';
import cors from 'cors';
import formularioRoutes from './routes/formulario.routes.js';
import kpiRoutes from './routes/kpi.routes.js';

const app = express();

app.use(cors({ origin: process.env.CORS_ORIGIN?.split(',') || '*' }));
app.use(express.json());

// Rutas
app.use('/api/formulario', formularioRoutes);
app.use('/api/kpis', kpiRoutes);

// Salud
app.get('/health', (_req, res) => res.json({ ok: true }));

export default app;
