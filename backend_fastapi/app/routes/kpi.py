from fastapi import APIRouter
from ..services.kpi_service import obtener_kpis

router = APIRouter(prefix="/api/kpis", tags=["KPIs"])

@router.get("/")
async def get_kpis():
    return await obtener_kpis()
