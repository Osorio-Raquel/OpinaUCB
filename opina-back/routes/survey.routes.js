// routes/survey.routes.js
import { Router } from 'express';
import {
  getCalidadAcademicaController,
  getExperienciaApoyoController,
  getInfraestructuraServiciosController,
  getSurveyByUserController
} from '../controllers/survey.controller.js';
import authMiddleware from '../middlewares/auth.middleware.js';
import { requireRole } from '../middlewares/auth.middleware.js';

const router = Router();

/**
 * @swagger
 * tags:
 *   name: Surveys
 *   description: Endpoints para gestionar encuestas
 */

/**
 * @swagger
 * /api/surveys/calidad-academica:
 *   get:
 *     summary: Obtener todos los registros de calidad académica
 *     tags: [Surveys]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de registros de calidad académica
 *       401:
 *         description: No autorizado
 *       500:
 *         description: Error del servidor
 */
router.get('/calidad-academica', authMiddleware, requireRole(['ADMINISTRADOR']), getCalidadAcademicaController);

/**
 * @swagger
 * /api/surveys/experiencia-apoyo:
 *   get:
 *     summary: Obtener todos los registros de experiencia y apoyo
 *     tags: [Surveys]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de registros de experiencia y apoyo
 *       401:
 *         description: No autorizado
 *       500:
 *         description: Error del servidor
 */
router.get('/experiencia-apoyo', authMiddleware, requireRole(['ADMINISTRADOR']), getExperienciaApoyoController);

/**
 * @swagger
 * /api/surveys/infraestructura-servicios:
 *   get:
 *     summary: Obtener todos los registros de infraestructura y servicios
 *     tags: [Surveys]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de registros de infraestructura y servicios
 *       401:
 *         description: No autorizado
 *       500:
 *         description: Error del servidor
 */
router.get('/infraestructura-servicios', authMiddleware, requireRole(['ADMINISTRADOR']), getInfraestructuraServiciosController);

/**
 * @swagger
 * /api/surveys/user/{table_name}/{usuario_id}:
 *   get:
 *     summary: Obtener encuestas de un usuario específico
 *     tags: [Surveys]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: table_name
 *         required: true
 *         schema:
 *           type: string
 *           enum: [calidad_academica, experiencia_apoyo, infraestructura_servicios]
 *         description: Nombre de la tabla
 *       - in: path
 *         name: usuario_id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID del usuario (UUID)
 *     responses:
 *       200:
 *         description: Datos de encuestas del usuario
 *       401:
 *         description: No autorizado
 *       404:
 *         description: Usuario no encontrado
 *       500:
 *         description: Error del servidor
 */
router.get('/user/:table_name/:usuario_id', authMiddleware, getSurveyByUserController);

export default router;