// routes/calidadAcademica.routes.js
import { Router } from 'express';
import authMiddleware from '../middlewares/auth.middleware.js';
import { postCalidadAcademica } from '../controllers/calidadAcademica.controller.js';

const router = Router();

/**
 * @swagger
 * tags:
 *   name: CalidadAcademica
 *   description: Endpoints de Calidad Académica
 */

/**
 * @swagger
 * /calidad-academica:
 *   post:
 *     summary: Crear nueva respuesta de calidad académica
 *     tags: [CalidadAcademica]
 *     security: [ { bearerAuth: [] } ]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               [pregunta1_claridad, pregunta2_preparacion_docentes, pregunta3_metodos_ensenanza,
 *                pregunta4_carga_horaria, pregunta5_programacion_horarios, pregunta6_satisfaccion_general]
 *             properties:
 *               pregunta1_claridad:
 *                 type: string
 *                 enum: ["Muy claro","Claro","Regular","Poco claro","Nada claro"]
 *               pregunta2_preparacion_docentes:
 *                 type: string
 *                 enum: ["Excelente","Buena","Regular","Deficiente","Muy deficiente"]
 *               pregunta3_metodos_ensenanza:
 *                 type: string
 *                 enum: ["Muy adecuados","Adecuados","Regulares","Poco adecuados","Nada adecuados"]
 *               pregunta4_carga_horaria:
 *                 type: string
 *                 enum: ["Muy adecuada","Adecuada","Regular","Excesiva","Insuficiente"]
 *               pregunta5_programacion_horarios:
 *                 type: string
 *                 enum: ["Muy flexible","Flexible","Regular","Poco flexible","Nada flexible"]
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
router.post('/', authMiddleware, postCalidadAcademica);

export default router;
