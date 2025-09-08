from ..config import supabase

async def obtener_kpis():
    total = supabase.table("respuestas_formulario").select("id", count="exact").execute()
    promedio = supabase.rpc("kpis_global").execute()  # si creaste la función en Supabase

    por_categoria = supabase.from_("kpis_por_categoria").select("*").execute()

    return {
        "global": {
            "total": total.count,
            "promedio": promedio.data[0]["promedio"] if promedio.data else 0,
        },
        "categorias": por_categoria.data if por_categoria.data else []
    }
