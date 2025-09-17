// services/user.service.js
import { createClient } from '@supabase/supabase-js';

// Obtener variables de entorno para la conexión con Supabase
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE; // 👈 usas tu var real

// Validar que las variables de entorno estén presentes
if (!supabaseUrl || !supabaseKey) {
  throw new Error('❌ Faltan SUPABASE_URL o SUPABASE_SERVICE_ROLE en .env');
}

// Crear cliente de Supabase con las credenciales
export const supabase = createClient(supabaseUrl, supabaseKey);

/**
 * Devuelve un usuario por correo desde public.usuario
 * @param {string} correo - Correo electrónico del usuario a buscar
 * @returns {Promise<Object|null>} Datos del usuario o null si no existe
 */
export async function getUserByEmail(correo) {
  const { data, error } = await supabase
    .from('usuario')
    .select('id, correo, contrasena, nombre, apellido_paterno, apellido_materno, anonimo, rol, creado_en')
    .eq('correo', correo)
    .maybeSingle(); // Retorna un solo registro o null

  if (error) {
    console.error('❌ Supabase getUserByEmail error:', error);
    throw error;
  }

  return data; // null si no existe
}

/**
 * Verifica si un correo electrónico ya está registrado en la base de datos
 * @param {string} correo - Correo electrónico a verificar
 * @returns {Promise<boolean>} True si el correo ya está tomado, false si está disponible
 */
export async function isEmailTaken(correo) {
  const { data, error } = await supabase
    .from('usuario')
    .select('id')
    .eq('correo', correo)
    .maybeSingle();

  // El código 'PGRST116' indica que no se encontraron resultados, lo cual no es un error real
  if (error && error.code !== 'PGRST116') {
    console.error('Supabase isEmailTaken error:', error);
    throw error;
  }
  return !!data; // Convierte el resultado a booleano (true si existe, false si no)
}

/**
 * Crea un nuevo usuario en la base de datos
 * @param {Object} userData - Datos del usuario a crear
 * @param {string} userData.correo - Correo electrónico
 * @param {string} userData.passwordHash - Contraseña hasheada
 * @param {string} userData.nombre - Nombre del usuario
 * @param {string} userData.apellido_paterno - Apellido paterno
 * @param {string} userData.apellido_materno - Apellido materno
 * @param {boolean} userData.anonimo - Indica si el usuario es anónimo
 * @param {string} userData.rol - Rol del usuario (por defecto 'ESTUDIANTE')
 * @returns {Promise<Object>} Datos del usuario creado (sin la contraseña)
 */
export async function createUser({
  correo,
  passwordHash,
  nombre,
  apellido_paterno,
  apellido_materno,
  anonimo = false,
  rol = 'ESTUDIANTE',
}) {
  // Preparar el objeto con los datos del usuario
  const payload = {
    id: crypto.randomUUID(), // Generar un ID único
    correo,
    contrasena: passwordHash, // Almacenar la contraseña hasheada
    nombre,
    apellido_paterno,
    apellido_materno,
    anonimo,
    rol,
  };

  // Insertar el usuario en la base de datos
  const { data, error } = await supabase
    .from('usuario')
    .insert([payload])
    .select('id, correo, nombre, apellido_paterno, apellido_materno, anonimo, rol, creado_en')
    .single(); // Retornar un solo objeto

  if (error) {
    console.error('Supabase createUser error:', error);
    throw error;
  }
  return data; // Retornar los datos del usuario creado
}