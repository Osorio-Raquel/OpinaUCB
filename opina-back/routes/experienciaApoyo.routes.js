// routes/experienciaApoyo.routes.js
import { Router } from 'express';
import authMiddleware from '../middlewares/auth.middleware.js';
import { postExperienciaApoyo } from '../controllers/experienciaApoyo.controller.js';

const router = Router();

/**
 * @swagger
 * /experiencia-apoyo:
 *   post:
 *     summary: Crear nueva respuesta de experiencia y apoyo
 *     tags: [ExperienciaApoyo]
 *     security: [ { bearerAuth: [] } ]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               [pregunta1_tutorias, pregunta2_orientacion, pregunta3_extracurriculares,
 *                pregunta4_apoyo_desarrollo, pregunta5_comunicacion, pregunta6_satisfaccion_general]
 *             properties:
 *               pregunta1_tutorias:
 *                 type: string
 *                 enum: ["Muy útiles","Útiles","Regulares","Poco útiles","Nada útiles"]
 *               pregunta2_orientacion:
 *                 type: string
 *                 enum: ["Muy accesibles","Accesibles","Regulares","Poco accesibles","Nada accesibles"]
 *               pregunta3_extracurriculares:
 *                 type: string
 *                 enum: ["Muy satisfecho","Satisfecho","Neutral","Insatisfecho","Muy insatisfecho"]
 *               pregunta4_apoyo_desarrollo:
 *                 type: string
 *                 enum: ["Excelente","Bueno","Regular","Deficiente","Muy deficiente"]
 *               pregunta5_comunicacion:
 *                 type: string
 *                 enum: ["Muy adecuada","Adecuada","Regular","Poco adecuada","Nada adecuada"]
 *               pregunta6_satisfaccion_general:
 *                 type: string
 *                 enum: ["Muy satisfecho","Satisfecho","Neutral","Insatisfecho","Muy insatisfecho"]
 *               pregunta7_sugerencias: { type: string }
 *     responses:
 *       201: { description: Creado }
 */
router.post('/', authMiddleware, postExperienciaApoyo);

export default router;
