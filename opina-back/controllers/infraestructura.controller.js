// controllers/infraestructura.controller.js
import { createInfraestructura } from '../services/infraestructura.service.js';

// Opciones EXACTAS según CHECKs de tu tabla
const OPCIONES = {
  pregunta1_salones: ['Muy adecuados','Adecuados','Regulares','Poco adecuados','Nada adecuados'],
  pregunta2_laboratorios: ['Excelente','Buena','Regular','Deficiente','Muy deficiente'],
  pregunta3_biblioteca: ['Muy útiles','Útiles','Regulares','Poco útiles','Nada útiles'],
  pregunta4_cafeteria: ['Muy satisfecho','Satisfecho','Neutral','Insatisfecho','Muy insatisfecho'],
  pregunta5_limpieza: ['Excelente','Buena','Regular','Deficiente','Muy deficiente'],
  pregunta6_satisfaccion_general: ['Muy satisfecho','Satisfecho','Neutral','Insatisfecho','Muy insatisfecho'],
};

function validate(body) {
  for (const [campo, opciones] of Object.entries(OPCIONES)) {
    if (!body[campo] || !opciones.includes(body[campo])) {
      throw new Error(`El campo ${campo} es inválido. Opciones: ${opciones.join(', ')}`);
    }
  }
}

export async function postInfraestructura(req, res) {
  try {
    validate(req.body);

    const row = await createInfraestructura(req.user.id, {
      ...req.body,
      // normalizamos sugerencias a null si viene vacía
      pregunta7_sugerencias: (req.body.pregunta7_sugerencias ?? '').trim() || null,
    });

    // Emitimos por WebSocket (si existe io)
    req.app.get('io')?.emit('infraestructura_servicios:created', row);

    res.status(201).json(row);
  } catch (err) {
    console.error('postInfraestructura error:', err);
    res.status(400).json({ message: err.message || 'Error creando infraestructura_servicios' });
  }
}
