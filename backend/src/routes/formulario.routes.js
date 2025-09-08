import { Router } from 'express';
import { crearRespuesta } from '../controllers/formulario.controller.js';

const router = Router();

/**
 * @openapi
 * /api/formulario:
 *   post:
 *     summary: Crear una respuesta de formulario
 *     tags: [Formulario]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/RespuestaFormularioInput'
 *     responses:
 *       200:
 *         description: Insertado correctamente
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/RespuestaOk'
 *       400:
 *         description: Datos inválidos
 *       500:
 *         description: Error del servidor
 */
router.post('/', crearRespuesta);

export default router;
