from fastapi import APIRouter
from ..services.kpi_service import obtener_kpis

router = APIRouter(prefix="/api/kpis", tags=["KPIs"])

@router.get("/", include_in_schema=True)   # con slash
@router.get("",  include_in_schema=False)  # sin slash
async def get_kpis():
    return await obtener_kpis()
