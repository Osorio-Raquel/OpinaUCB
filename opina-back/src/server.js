import http from 'http';
import { Server } from 'socket.io';
import { app } from './app.js';
import 'dotenv/config';

const PORT = process.env.PORT || 3000;
const server = http.createServer(app);

// Sockets básicos
const io = new Server(server, {
  cors: { origin: '*', methods: ['GET', 'POST'] }
});

// Opcional: exponer io para usarlo en rutas/servicios
app.set('io', io);

io.on('connection', (socket) => {
  console.log('⚡ socket conectado:', socket.id);
  socket.on('disconnect', () => console.log('👋 socket fuera:', socket.id));
});

server.listen(PORT, () => {
  console.log(`API lista en http://localhost:${PORT}`);
  console.log(`Swagger UI en http://localhost:${PORT}/api-docs`);
});
