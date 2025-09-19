// services/calidadAcademica.service.js
import { supabase } from '../config/supabaseClient.js';

export async function createCalidadAcademica(usuarioId, body) {
  const payload = { ...body, usuario_id: usuarioId };
  const { data, error } = await supabase
    .from('calidad_academica')
    .insert([payload])
    .select('*')
    .single();

  if (error) throw error;
  return data;
}
