from fastapi import FastAPI
from .routes import formulario, kpi
from .sockets.realtime import socket_app

app = FastAPI(
    title="API Formularios KPIs - FastAPI",
    version="1.0.0"
)

app.include_router(formulario.router)
app.include_router(kpi.router)

# Montamos el socket.io server
import uvicorn
if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=3000, reload=True)
