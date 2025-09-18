// services/experienciaApoyo.service.js
import { supabase } from '../config/supabaseClient.js';

export async function createExperienciaApoyo(usuarioId, body) {
  const payload = { ...body, usuario_id: usuarioId };
  const { data, error } = await supabase
    .from('experiencia_apoyo')
    .insert([payload])
    .select('*')
    .single();

  if (error) throw error;
  return data;
}
