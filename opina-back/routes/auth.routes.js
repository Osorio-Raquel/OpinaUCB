// routes/auth.routes.js
import { Router } from 'express';
import { login, register, getMe } from '../controllers/auth.controller.js';
import authMiddleware from '../middlewares/auth.middleware.js';

const router = Router();

/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Endpoints de autenticación
 */

/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Inicia sesión en la aplicación
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [correo, contrasena]
 *             properties:
 *               correo:
 *                 type: string
 *                 example: usuario@test.com
 *               contrasena:
 *                 type: string
 *                 example: 123456
 *     responses:
 *       200: { description: Login exitoso }
 *       401: { description: Credenciales inválidas }
 *       404: { description: Usuario no encontrado }
 */
router.post('/login', login);

/**
 * @swagger
 * /auth/register:
 *   post:
 *     summary: Registrar un nuevo usuario
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [correo, contrasena, nombre, apellido_paterno, apellido_materno]
 *             properties:
 *               correo: { type: string, example: nuevo@ucb.edu.bo }
 *               contrasena: { type: string, example: 123456 }
 *               nombre: { type: string, example: Ana }
 *               apellido_paterno: { type: string, example: López }
 *               apellido_materno: { type: string, example: Ramírez }
 *               anonimo: { type: boolean, example: false }
 *               rol: { type: string, example: ESTUDIANTE }
 *     responses:
 *       201: { description: Usuario creado }
 *       409: { description: Correo ya registrado }
 */
router.post('/register', register);

/**
 * @swagger
 * /auth/me:
 *   get:
 *     summary: Obtiene la información del usuario autenticado
 *     tags: [Auth]
 *     security: [ { bearerAuth: [] } ]
 *     responses:
 *       200: { description: Datos del usuario autenticado }
 *       401: { description: Token requerido }
 *       403: { description: Token inválido o expirado }
 */
router.get('/me', authMiddleware, getMe);

export default router;
