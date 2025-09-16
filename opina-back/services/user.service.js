const pool = require("../config/db"); // tu conexión a PostgreSQL

const getUserByEmail = async (correo) => {
  const result = await pool.query(
    "SELECT * FROM usuario WHERE correo = $1 LIMIT 1",
    [correo]
  );
  return result.rows[0];
};

module.exports = { getUserByEmail };
