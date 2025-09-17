import http from 'http';
import { Server } from 'socket.io';
import { app } from './app.js';
import 'dotenv/config';

const PORT = process.env.PORT || 3000;

const server = http.createServer(app);

const io = new Server(server, {
  cors: { origin: true, credentials: true }, // dev
});

app.set('io', io);

io.on('connection', (socket) => {
  console.log('⚡ socket conectado:', socket.id);
  socket.on('disconnect', () => console.log('👋 socket fuera:', socket.id));
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`API escuchando en http://localhost:${PORT}`);
  if (process.env.NGROK_URL) {
    console.log(`(túnel) ${process.env.NGROK_URL}`);
    console.log(`Swagger: ${process.env.NGROK_URL}/api-docs`);
  } else {
    console.log(`Swagger: http://localhost:${PORT}/api-docs`);
  }
});
