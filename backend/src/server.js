import 'dotenv/config';
import http from 'http';
import { Server } from 'socket.io';
import app from './app.js';
import { initRealtimeGateway, emitirKPIsInstantaneo } from './sockets/realtime.gateway.js';

const server = http.createServer(app);

const io = new Server(server, {
  cors: { origin: process.env.CORS_ORIGIN?.split(',') || '*' }
});

// Inicializa gateway WS
initRealtimeGateway(io);

// (opcional) emite un snapshot al arrancar
emitirKPIsInstantaneo(io).catch(console.error);

const port = process.env.PORT || 3000;
server.listen(port, () => {
  console.log(`API + WS escuchando en http://localhost:${port}`);
});
