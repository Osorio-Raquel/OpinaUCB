from fastapi import APIRouter
from ..models.respuesta import RespuestaFormulario
from ..services.supabase_service import insertar_respuesta
from ..sockets.realtime import emitir_kpis

router = APIRouter(prefix="/api/formulario", tags=["Formulario"])

@router.post("/", include_in_schema=True)   # con slash
@router.post("",  include_in_schema=False)  # sin slash
async def crear_respuesta(data: RespuestaFormulario):
    await insertar_respuesta(data)
    await emitir_kpis()
    return {"ok": True}
