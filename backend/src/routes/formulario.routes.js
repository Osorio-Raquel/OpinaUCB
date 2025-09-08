import { Router } from 'express';
import { crearRespuesta } from '../controllers/formulario.controller.js';

const router = Router();

router.post('/', crearRespuesta); // POST /api/formulario

export default router;
