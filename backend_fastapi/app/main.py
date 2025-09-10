import socketio
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routes import formulario, kpi
from .sockets.realtime import sio

# 1) Instancia FastAPI
_fastapi = FastAPI(title="API Formularios KPIs - FastAPI", version="1.0.0")

# 2) Configurar CORS (aquí metes el túnel ngrok)
_fastapi.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",        
        "http://10.0.2.2:3000",         
        "https://1e0bfa79ecdd.ngrok-free.app",       # 👉 cambia por el túnel actual
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


_fastapi.include_router(formulario.router)
_fastapi.include_router(kpi.router)

app = socketio.ASGIApp(
    sio,
    other_asgi_app=_fastapi,
    socketio_path="/socket.io/"
)
