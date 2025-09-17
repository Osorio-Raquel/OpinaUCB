// controllers/auth.controller.js
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { getUserByEmail, isEmailTaken, createUser } from '../services/user.service.js';

const JWT_EXPIRES = process.env.JWT_EXPIRES || '1h';

export const login = async (req, res) => {
  try {
    const email = (req.body.correo || '').trim().toLowerCase();
    const pass  = (req.body.contrasena || '').trim();

    if (!email || !pass) {
      return res.status(400).json({ message: 'Faltan campos' });
    }

    const user = await getUserByEmail(email);
    if (!user) return res.status(404).json({ message: 'Usuario no encontrado' });

    const ok = await bcrypt.compare(pass, user.contrasena || '');
    if (!ok) return res.status(401).json({ message: 'Credenciales inválidas' });

    const token = jwt.sign(
      { id: user.id, correo: user.correo, rol: user.rol },
      process.env.JWT_SECRET,
      { expiresIn: JWT_EXPIRES }
    );

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

export const register = async (req, res) => {
  try {
    const {
      correo,
      contrasena,
      nombre,
      apellido_paterno,
      apellido_materno,
      anonimo = false,
      rol = 'ESTUDIANTE',
    } = req.body || {};

    const email = (correo || '').trim().toLowerCase();
    const pass  = (contrasena || '').trim();

    if (!email || !pass || !nombre || !apellido_paterno || !apellido_materno) {
      return res.status(400).json({ message: 'Todos los campos obligatorios deben enviarse' });
    }

    if (await isEmailTaken(email)) {
      return res.status(409).json({ message: 'El correo ya está registrado' });
    }

    const hash = await bcrypt.hash(pass, 10);
    const user = await createUser({
      correo: email,
      passwordHash: hash,
      nombre,
      apellido_paterno,
      apellido_materno,
      anonimo,
      rol,
    });

    return res.status(201).json({
      message: 'Usuario creado exitosamente',
      user
    });
  } catch (error) {
    console.error('register error:', error);
    res.status(500).json({ message: 'Error en el servidor' });
  }
};

export const getMe = async (req, res) => {
  try {
    res.json({ user: req.user });
  } catch (error) {
    console.error('getMe error:', error);
    res.status(500).json({ message: 'Error en el servidor' });
  }
};
