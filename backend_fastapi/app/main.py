import socketio
from fastapi import FastAPI
from .routes import formulario, kpi
from .sockets.realtime import sio

_fastapi = FastAPI(title="API Formularios KPIs - FastAPI", version="1.0.0")
_fastapi.include_router(formulario.router)
_fastapi.include_router(kpi.router)

# Monta Socket.IO en /socket.io/ explícito
app = socketio.ASGIApp(
    sio,
    other_asgi_app=_fastapi,
    socketio_path="/socket.io/"
)
