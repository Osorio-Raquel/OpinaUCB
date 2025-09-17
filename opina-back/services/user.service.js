// services/user.service.js
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE; // 👈 usas tu var real

if (!supabaseUrl || !supabaseKey) {
  throw new Error('❌ Faltan SUPABASE_URL o SUPABASE_SERVICE_ROLE en .env');
}

export const supabase = createClient(supabaseUrl, supabaseKey);

/**
 * Devuelve un usuario por correo desde public.usuario
 */
export async function getUserByEmail(correo) {
  const { data, error } = await supabase
    .from('usuario')
    .select('id, correo, contrasena, nombre, apellido_paterno, apellido_materno, anonimo, rol, creado_en')
    .eq('correo', correo)
    .maybeSingle();

  if (error) {
    console.error('❌ Supabase getUserByEmail error:', error);
    throw error;
  }

  return data; // null si no existe
}

export async function isEmailTaken(correo) {
  const { data, error } = await supabase
    .from('usuario')
    .select('id')
    .eq('correo', correo)
    .maybeSingle();

  if (error && error.code !== 'PGRST116') { // not found no es error
    console.error('Supabase isEmailTaken error:', error);
    throw error;
  }
  return !!data;
}

export async function createUser({
  correo,
  passwordHash,
  nombre,
  apellido_paterno,
  apellido_materno,
  anonimo = false,
  rol = 'ESTUDIANTE',
}) {
  const payload = {
    id: crypto.randomUUID(),
    correo,
    contrasena: passwordHash,
    nombre,
    apellido_paterno,
    apellido_materno,
    anonimo,
    rol,
  };

  const { data, error } = await supabase
    .from('usuario')
    .insert([payload])
    .select('id, correo, nombre, apellido_paterno, apellido_materno, anonimo, rol, creado_en')
    .single();

  if (error) {
    console.error('Supabase createUser error:', error);
    throw error;
  }
  return data;
}