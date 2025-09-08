import { Router } from 'express';
import { obtenerKPIs } from '../controllers/kpi.controller.js';

const router = Router();

router.get('/', obtenerKPIs);

export default router;
