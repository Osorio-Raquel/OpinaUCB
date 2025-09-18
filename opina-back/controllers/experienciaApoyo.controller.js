// controllers/experienciaApoyo.controller.js
import { createExperienciaApoyo } from '../services/experienciaApoyo.service.js';

const OPCIONES = {
  pregunta1_tutorias: ['Muy útiles','Útiles','Regulares','Poco útiles','Nada útiles'],
  pregunta2_orientacion: ['Muy accesibles','Accesibles','Regulares','Poco accesibles','Nada accesibles'],
  pregunta3_extracurriculares: ['Muy satisfecho','Satisfecho','Neutral','Insatisfecho','Muy insatisfecho'],
  pregunta4_apoyo_desarrollo: ['Excelente','Bueno','Regular','Deficiente','Muy deficiente'],
  pregunta5_comunicacion: ['Muy adecuada','Adecuada','Regular','Poco adecuada','Nada adecuada'],
  pregunta6_satisfaccion_general: ['Muy satisfecho','Satisfecho','Neutral','Insatisfecho','Muy insatisfecho'],
};

function validate(body) {
  for (const [campo, opciones] of Object.entries(OPCIONES)) {
    if (!body[campo] || !opciones.includes(body[campo])) {
      throw new Error(`El campo ${campo} es inválido. Opciones: ${opciones.join(', ')}`);
    }
  }
}

export async function postExperienciaApoyo(req, res) {
  try {
    validate(req.body);
    const row = await createExperienciaApoyo(req.user.id, req.body);

    // Emitimos al WS
    req.app.get('io').emit('experiencia_apoyo:created', row);

    res.status(201).json(row);
  } catch (err) {
    console.error('postExperienciaApoyo error:', err);
    res.status(400).json({ message: err.message || 'Error creando experiencia_apoyo' });
  }
}
