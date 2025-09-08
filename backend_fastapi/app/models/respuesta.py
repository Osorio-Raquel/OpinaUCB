from pydantic import BaseModel
from typing import Optional

class RespuestaFormulario(BaseModel):
    usuario_id: Optional[str]
    edad: Optional[int]
    genero: Optional[str]
    ciudad: Optional[str]
    categoria: str
    satisfaccion: int
    calidad_servicio: Optional[int]
    recomendar: Optional[str]
    comentario: Optional[str]
