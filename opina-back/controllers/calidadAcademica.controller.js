// controllers/calidadAcademica.controller.js
import { createCalidadAcademica } from '../services/calidadAcademica.service.js';

// Opciones EXACTAS según los CHECKs de tu tabla
const OPCIONES = {
  pregunta1_claridad: ['Muy claro','Claro','Regular','Poco claro','Nada claro'],
  pregunta2_preparacion_docentes: ['Excelente','Buena','Regular','Deficiente','Muy deficiente'],
  pregunta3_metodos_ensenanza: ['Muy adecuados','Adecuados','Regulares','Poco adecuados','Nada adecuados'],
  pregunta4_carga_horaria: ['Muy adecuada','Adecuada','Regular','Excesiva','Insuficiente'],
  pregunta5_programacion_horarios: ['Muy flexible','Flexible','Regular','Poco flexible','Nada flexible'],
  pregunta6_satisfaccion_general: ['Muy satisfecho','Satisfecho','Neutral','Insatisfecho','Muy insatisfecho'],
};

function validate(body) {
  for (const [campo, opciones] of Object.entries(OPCIONES)) {
    if (!body[campo] || !opciones.includes(body[campo])) {
      throw new Error(`El campo ${campo} es inválido. Opciones: ${opciones.join(', ')}`);
    }
  }
}

export async function postCalidadAcademica(req, res) {
  try {
    validate(req.body);

    const row = await createCalidadAcademica(req.user.id, {
      ...req.body,
      // normaliza sugerencias a null si viene vacía
      pregunta7_sugerencias: (req.body.pregunta7_sugerencias ?? '').trim() || null,
    });

    // Emitimos por WS (si existe)
    req.app.get('io')?.emit('calidad_academica:created', row);

    res.status(201).json(row);
  } catch (err) {
    console.error('postCalidadAcademica error:', err);
    res.status(400).json({ message: err.message || 'Error creando calidad_academica' });
  }
}
