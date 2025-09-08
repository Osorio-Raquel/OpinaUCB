import socketio
from ..services.kpi_service import obtener_kpis

# importante: async_mode='asgi' y CORS abierto en dev
sio = socketio.AsyncServer(cors_allowed_origins="*", async_mode="asgi")

async def emitir_kpis():
    await sio.emit("metric:update", await obtener_kpis())

@sio.event
async def connect(sid, environ):
    await emitir_kpis()
