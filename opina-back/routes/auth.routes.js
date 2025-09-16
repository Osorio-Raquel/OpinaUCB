const express = require('express');
const router = express.Router();
const { login, getMe } = require('../controllers/auth.controller');
const authenticateToken = require('../middlewares/auth.middleware');


/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Endpoints de autenticación
 */
//rutas.post('/login') -> /api/auth/login
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
 *             required:
 *               - correo
 *               - contrasena
 *             properties:
 *               correo:
 *                 type: string
 *                 example: usuario@test.com
 *               contrasena:
 *                 type: string
 *                 example: 123456
 *     responses:
 *       200:
 *         description: Login exitoso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Login exitoso
 *                 token:
 *                   type: string
 *                   example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
 *                 user:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                       format: uuid
 *                     correo:
 *                       type: string
 *                     nombre:
 *                       type: string
 *                     apellido_paterno:
 *                       type: string
 *                     apellido_materno:
 *                       type: string
 *                     anonimo:
 *                       type: boolean
 *                     rol:
 *                       type: string
 *                     creado_en:
 *                       type: string
 *                       format: date-time
 *       401:
 *         description: Credenciales inválidas
 *       404:
 *         description: Usuario no encontrado
 */
router.post('/login', login);
//ruta.get('/me') -> /api/auth/me
/**
 * @swagger
 * /auth/me:
 *   get:
 *     summary: Obtiene la información del usuario autenticado
 *     tags: [Auth]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Datos del usuario autenticado
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 user:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                       format: uuid
 *                     correo:
 *                       type: string
 *                     rol:
 *                       type: string
 *       401:
 *         description: Token requerido
 *       403:
 *         description: Token inválido o expirado
 */
router.get('/me', authenticateToken, getMe);

module.exports = router;
