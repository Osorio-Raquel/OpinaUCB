from fastapi import APIRouter
from ..models.respuesta import RespuestaFormulario
from ..services.supabase_service import insertar_respuesta
from ..sockets.realtime import emitir_kpis

router = APIRouter(prefix="/api/formulario", tags=["Formulario"])

@router.post("/")
async def crear_respuesta(data: RespuestaFormulario):
    r = await insertar_respuesta(data)
    await emitir_kpis()
    return {"ok": True, "data": r}
