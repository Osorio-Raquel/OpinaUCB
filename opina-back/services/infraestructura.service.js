// services/infraestructura.service.js
import { supabase } from '../config/supabaseClient.js';

export async function createInfraestructura(usuarioId, body) {
  const payload = { ...body, usuario_id: usuarioId };
  const { data, error } = await supabase
    .from('infraestructura_servicios')
    .insert([payload])
    .select('*')
    .single();

  if (error) throw error;
  return data;
}
