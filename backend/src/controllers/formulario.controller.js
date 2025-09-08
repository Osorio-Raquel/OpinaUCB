import { insertarRespuesta } from '../services/formulario.service.js';
import { emitirKPIsInstantaneo } from '../sockets/realtime.gateway.js';

export async function crearRespuesta(req, res) {
  try {
    const payload = req.body; 
    await insertarRespuesta(payload);

    await emitirKPIsInstantaneo(req.app.get('io') || global.__io);

    res.json({ ok: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'No se pudo guardar la respuesta' });
  }
}
