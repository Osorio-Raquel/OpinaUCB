const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const { getUserByEmail } = require("../services/user.service");

const login = async (req, res) => {
  try {
    const { correo, contrasena } = req.body;

    // Buscar usuario
    const user = await getUserByEmail(correo);
    if (!user) return res.status(404).json({ message: "Usuario no encontrado" });

    // Verificar contraseña
    const validPassword = await bcrypt.compare(contrasena, user.contrasena);
    if (!validPassword) return res.status(401).json({ message: "Credenciales inválidas" });

    // Generar token
    const token = jwt.sign(
      { id: user.id, correo: user.correo, rol: user.rol },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );

    res.json({
      message: "Login exitoso",
      token,
      user: {
        id: user.id,
        correo: user.correo,
        nombre: user.nombre,
        apellido_paterno: user.apellido_paterno,
        apellido_materno: user.apellido_materno,
        anonimo: user.anonimo,
        rol: user.rol,
        creado_en: user.creado_en
      }
    });
  } catch (error) {
    res.status(500).json({ message: "Error en el servidor", error });
  }
};

const getMe = async (req, res) => {
  try {
    const user = req.user; // viene del middleware
    res.json({ user });
  } catch (error) {
    res.status(500).json({ message: "Error en el servidor", error });
  }
};

module.exports = { login, getMe };
