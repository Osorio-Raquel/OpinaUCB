import { kpiGlobal, kpiPorCategoria } from '../services/kpi.service.js';

export function initRealtimeGateway(io) {
  // guarda referencia global para usar desde controllers
  global.__io = io;

  io.on('connection', async (socket) => {
    try {
      const [globalK, catK] = await Promise.all([kpiGlobal(), kpiPorCategoria()]);
      socket.emit('metric:update', { global: globalK, categorias: catK });
    } catch (e) {
      console.error('Error enviando snapshot WS', e);
    }
  });
}

export async function emitirKPIsInstantaneo(io) {
  const target = io || global.__io;
  if (!target) return;
  const [globalK, catK] = await Promise.all([kpiGlobal(), kpiPorCategoria()]);
  target.emit('metric:update', { global: globalK, categorias: catK });
}
