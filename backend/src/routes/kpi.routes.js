import { Router } from 'express';
import { obtenerKPIs } from '../controllers/kpi.controller.js';

const router = Router();

/**
 * @openapi
 * /api/kpis:
 *   get:
 *     summary: Obtener KPIs (globales y por categoría)
 *     tags: [KPIs]
 *     responses:
 *       200:
 *         description: KPIs actuales
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/KPIsResponse'
 *       500:
 *         description: Error del servidor
 */
router.get('/', obtenerKPIs);

export default router;
