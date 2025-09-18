// controllers/survey.controller.js
import {
  getCalidadAcademica,
  getExperienciaApoyo,
  getInfraestructuraServicios,
  getSurveyByUser
} from '../services/survey.service.js';

/**
 * Controlador para obtener todos los registros de calidad_academica
 * @param {Object} req - Request object
 * @param {Object} res - Response object
 */
export const getCalidadAcademicaController = async (req, res) => {
  try {
    const data = await getCalidadAcademica();
    res.json({
      success: true,
      data: data,
      count: data.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

/**
 * Controlador para obtener todos los registros de experiencia_apoyo
 * @param {Object} req - Request object
 * @param {Object} res - Response object
 */
export const getExperienciaApoyoController = async (req, res) => {
  try {
    const data = await getExperienciaApoyo();
    res.json({
      success: true,
      data: data,
      count: data.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

/**
 * Controlador para obtener todos los registros de infraestructura_servicios
 * @param {Object} req - Request object
 * @param {Object} res - Response object
 */
export const getInfraestructuraServiciosController = async (req, res) => {
  try {
    const data = await getInfraestructuraServicios();
    res.json({
      success: true,
      data: data,
      count: data.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

/**
 * Controlador para obtener datos de una tabla específica por usuario_id
 * @param {Object} req - Request object
 * @param {Object} res - Response object
 */
export const getSurveyByUserController = async (req, res) => {
  try {
    const { table_name, usuario_id } = req.params;
    const data = await getSurveyByUser(table_name, usuario_id);
    
    res.json({
      success: true,
      data: data,
      count: data.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};