// services/survey.service.js
import { supabase } from './user.service.js';

/**
 * Servicio para obtener todos los registros de calidad_academica
 * @returns {Array} - Array con todos los registros de la tabla
 */
export const getCalidadAcademica = async () => {
  try {
    const { data, error } = await supabase
      .from('calidad_academica')
      .select('*');

    if (error) {
      console.error('Error en getCalidadAcademica:', error);
      throw new Error('Error al obtener datos de calidad académica');
    }

    return data;
  } catch (error) {
    console.error('Error en getCalidadAcademica:', error);
    throw new Error('Error al obtener datos de calidad académica');
  }
};

/**
 * Servicio para obtener todos los registros de experiencia_apoyo
 * @returns {Array} - Array con todos los registros de la tabla
 */
export const getExperienciaApoyo = async () => {
  try {
    const { data, error } = await supabase
      .from('experiencia_apoyo')
      .select('*');

    if (error) {
      console.error('Error en getExperienciaApoyo:', error);
      throw new Error('Error al obtener datos de experiencia y apoyo');
    }

    return data;
  } catch (error) {
    console.error('Error en getExperienciaApoyo:', error);
    throw new Error('Error al obtener datos de experiencia y apoyo');
  }
};

/**
 * Servicio para obtener todos los registros de infraestructura_servicios
 * @returns {Array} - Array con todos los registros de la tabla
 */
export const getInfraestructuraServicios = async () => {
  try {
    const { data, error } = await supabase
      .from('infraestructura_servicios')
      .select('*');

    if (error) {
      console.error('Error en getInfraestructuraServicios:', error);
      throw new Error('Error al obtener datos de infraestructura y servicios');
    }

    return data;
  } catch (error) {
    console.error('Error en getInfraestructuraServicios:', error);
    throw new Error('Error al obtener datos de infraestructura y servicios');
  }
};

/**
 * Servicio para obtener datos de una tabla específica por usuario_id
 * @param {String} tableName - Nombre de la tabla
 * @param {String} usuarioId - ID del usuario
 * @returns {Array} - Registros del usuario específico
 */
export const getSurveyByUser = async (tableName, usuarioId) => {
  try {
    const validTables = ['calidad_academica', 'experiencia_apoyo', 'infraestructura_servicios'];
    
    if (!validTables.includes(tableName)) {
      throw new Error('Tabla no válida');
    }

    const { data, error } = await supabase
      .from(tableName)
      .select('*')
      .eq('usuario_id', usuarioId);

    if (error) {
      console.error(`Error en getSurveyByUser para tabla ${tableName}:`, error);
      throw new Error(`Error al obtener datos de ${tableName} para el usuario`);
    }

    return data;
  } catch (error) {
    console.error(`Error en getSurveyByUser para tabla ${tableName}:`, error);
    throw new Error(`Error al obtener datos de ${tableName} para el usuario`);
  }
};