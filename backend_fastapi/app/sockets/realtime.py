import socketio
from fastapi import FastAPI
from ..services.kpi_service import obtener_kpis

sio = socketio.AsyncServer(cors_allowed_origins="*")
socket_app = socketio.ASGIApp(sio)

async def emitir_kpis():
    kpis = await obtener_kpis()
    await sio.emit("metric:update", kpis)

@sio.event
async def connect(sid, environ):
    print("🔌 Cliente conectado:", sid)
    await emitir_kpis()
