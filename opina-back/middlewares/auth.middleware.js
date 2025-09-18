// middlewares/auth.middleware.js
import jwt from 'jsonwebtoken';

/**
 * Middleware de autenticación para verificar tokens JWT
 * Este middleware se encarga de validar la autenticidad y vigencia
 * de los tokens JWT en las solicitudes protegidas
 */
export default function authMiddleware(req, res, next) {
  // Extraer el token del header 'Authorization' con formato: "Bearer <token>"
  const token = req.headers['authorization']?.split(' ')[1];

  // Si no hay token, retornar error 401 (No autorizado)
  if (!token) return res.status(401).json({ message: 'Token requerido' });

  try {
    // Verificar y decodificar el token usando la clave secreta JWT
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Adjuntar la información del usuario decodificada al objeto de solicitud (req)
    // Esto permite que las rutas posteriores accedan a la información del usuario
    req.user = decoded; // Estructura esperada: { id, correo, rol }
    
    // Continuar con el siguiente middleware o controlador
    next();
  } catch (error) {
    // Si el token es inválido o ha expirado, retornar error 403 (Prohibido)
    return res.status(403).json({ message: 'Token inválido o expirado' });
  }
}
/**
 * Middleware para verificación de roles
 * Puede ser usado después de authMiddleware para restringir acceso por roles
 * @param {Array} allowedRoles - Array de roles permitidos
 */
export const requireRole = (allowedRoles) => {
  return (req, res, next) => {
    // Verificar que el usuario esté autenticado (debe ejecutarse después de authMiddleware)
    if (!req.user) {
      return res.status(401).json({ message: 'Usuario no autenticado' });
    }
    
    // Verificar si el rol del usuario está en los roles permitidos
    if (!allowedRoles.includes(req.user.rol)) {
      return res.status(403).json({ 
        message: 'Permisos insuficientes',
        error: `El rol ${req.user.rol} no tiene acceso a este recurso` 
      });
    }
    
    next();
  };
};