// routes/infraestructura.routes.js
import { Router } from 'express';
import authMiddleware from '../middlewares/auth.middleware.js';
import { postInfraestructura } from '../controllers/infraestructura.controller.js';

const router = Router();

/**
 * @swagger
 * tags:
 *   name: InfraestructuraServicios
 *   description: Endpoints de Infraestructura y Servicios
 */

/**
 * @swagger
 * /infraestructura-servicios:
 *   post:
 *     summary: Crear nueva respuesta de infraestructura y servicios
 *     tags: [InfraestructuraServicios]
 *     security: [ { bearerAuth: [] } ]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               [pregunta1_salones, pregunta2_laboratorios, pregunta3_biblioteca,
 *                pregunta4_cafeteria, pregunta5_limpieza, pregunta6_satisfaccion_general]
 *             properties:
 *               pregunta1_salones:
 *                 type: string
 *                 enum: ["Muy adecuados","Adecuados","Regulares","Poco adecuados","Nada adecuados"]
 *               pregunta2_laboratorios:
 *                 type: string
 *                 enum: ["Excelente","Buena","Regular","Deficiente","Muy deficiente"]
 *               pregunta3_biblioteca:
 *                 type: string
 *                 enum: ["Muy útiles","Útiles","Regulares","Poco útiles","Nada útiles"]
 *               pregunta4_cafeteria:
 *                 type: string
 *                 enum: ["Muy satisfecho","Satisfecho","Neutral","Insatisfecho","Muy insatisfecho"]
 *               pregunta5_limpieza:
 *                 type: string
 *                 enum: ["Excelente","Buena","Regular","Deficiente","Muy deficiente"]
 *               pregunta6_satisfaccion_general:
 *                 type: string
 *                 enum: ["Muy satisfecho","Satisfecho","Neutral","Insatisfecho","Muy insatisfecho"]
 *               pregunta7_sugerencias:
 *                 type: string
 *                 nullable: true
 *     responses:
 *       201: { description: Creado }
 *       400: { description: Datos inválidos }
 *       401: { description: No autorizado }
 */
router.post('/', authMiddleware, postInfraestructura);

export default router;
