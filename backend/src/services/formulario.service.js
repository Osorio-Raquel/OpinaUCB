import supabase from '../config/supabase.js';

function validar(payload) {
  const { categoria, satisfaccion } = payload || {};
  if (!categoria) throw new Error('categoria requerida');
  if (typeof satisfaccion !== 'number') throw new Error('satisfaccion requerida (1..5)');
}

export async function insertarRespuesta(payload) {
  validar(payload);
  const {
    usuario_id,
    edad,
    genero,            // 'Masculino' | 'Femenino' | 'Otro'
    ciudad,
    categoria,         // 'Docentes' | 'Infraestructura' | 'Servicios' | 'Administración'
    satisfaccion,      // 1..5
    calidad_servicio,  // 1..5
    recomendar,        // 'Sí' | 'No'
    comentario
  } = payload;

  const { error } = await supabase.from('respuestas_formulario').insert({
    usuario_id: usuario_id || null,
    edad: edad ?? null,
    genero: genero || null,
    ciudad: ciudad || null,
    categoria,
    satisfaccion,
    calidad_servicio: calidad_servicio ?? null,
    recomendar: recomendar || null,
    comentario: comentario || null
  });

  if (error) throw error;
}
