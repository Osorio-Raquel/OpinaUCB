// controllers/auth.controller.js
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { getUserByEmail, isEmailTaken, createUser } from '../services/user.service.js';

// Tiempo de expiración del token JWT (por defecto 1 hora)
const JWT_EXPIRES = process.env.JWT_EXPIRES || '1h';

/**
 * Controlador para el inicio de sesión de usuarios
 * Verifica credenciales y genera un token JWT si son válidas
 */
export const login = async (req, res) => {
  try {
    // Normalizar y limpiar datos de entrada
    const email = (req.body.correo || '').trim().toLowerCase();
    const pass  = (req.body.contrasena || '').trim();

    // Validar que todos los campos requeridos estén presentes
    if (!email || !pass) {
      return res.status(400).json({ message: 'Faltan campos' });
    }

    // Buscar usuario por email
    const user = await getUserByEmail(email);
    if (!user) return res.status(404).json({ message: 'Usuario no encontrado' });

    // Verificar contraseña usando bcrypt
    const ok = await bcrypt.compare(pass, user.contrasena || '');
    if (!ok) return res.status(401).json({ message: 'Credenciales inválidas' });

    // Generar token JWT con información del usuario
    const token = jwt.sign(
      { id: user.id, correo: user.correo, rol: user.rol },
      process.env.JWT_SECRET,
      { expiresIn: JWT_EXPIRES }
    );

    // Responder con token y datos del usuario (sin información sensible)
    res.json({
      message: 'Login exitoso',
      token,
      user: {
        id: user.id,
        correo: user.correo,
        nombre: user.nombre,
        apellido_paterno: user.apellido_paterno,
        apellido_materno: user.apellido_materno,
        anonimo: user.anonimo,
        rol: user.rol,
        creado_en: user.creado_en,
      }
    });
  } catch (error) {
    console.error('login error:', error);
    res.status(500).json({ message: 'Error en el servidor' });
  }
};

/**
 * Controlador para el registro de nuevos usuarios
 * Crea un nuevo usuario en la base de datos después de validaciones
 */
export const register = async (req, res) => {
  try {
    // Extraer datos del cuerpo de la solicitud
    const {
      correo,
      contrasena,
      nombre,
      apellido_paterno,
      apellido_materno,
      anonimo = false,
      rol = 'ESTUDIANTE',
    } = req.body || {};

    // Normalizar y limpiar datos
    const email = (correo || '').trim().toLowerCase();
    const pass  = (contrasena || '').trim();

    // Validar campos obligatorios
    if (!email || !pass || !nombre || !apellido_paterno || !apellido_materno) {
      return res.status(400).json({ message: 'Todos los campos obligatorios deben enviarse' });
    }

    // Verificar si el correo ya está registrado
    if (await isEmailTaken(email)) {
      return res.status(409).json({ message: 'El correo ya está registrado' });
    }

    // Hashear contraseña antes de almacenarla
    const hash = await bcrypt.hash(pass, 10);
    
    // Crear nuevo usuario en la base de datos
    const user = await createUser({
      correo: email,
      passwordHash: hash,
      nombre,
      apellido_paterno,
      apellido_materno,
      anonimo,
      rol,
    });

    // Responder con éxito y datos del usuario creado
    return res.status(201).json({
      message: 'Usuario creado exitosamente',
      user
    });
  } catch (error) {
    console.error('register error:', error);
    res.status(500).json({ message: 'Error en el servidor' });
  }
};

/**
 * Controlador para obtener información del usuario autenticado
 * Utiliza el middleware de autenticación que adjunta user al request
 */
export const getMe = async (req, res) => {
  try {
    // Simplemente devuelve la información del usuario que ya está en req.user
    // gracias al middleware de autenticación
    res.json({ user: req.user });
  } catch (error) {
    console.error('getMe error:', error);
    res.status(500).json({ message: 'Error en el servidor' });
  }
};