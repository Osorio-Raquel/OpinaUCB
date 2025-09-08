from ..config import supabase
from ..models.respuesta import RespuestaFormulario

async def insertar_respuesta(data: RespuestaFormulario):
    res = supabase.table("respuestas_formulario").insert(data.dict()).execute()
    return res.data
