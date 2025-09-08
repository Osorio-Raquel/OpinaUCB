from ..config import supabase

async def obtener_kpis():
    # COUNT exacto
    total_resp = supabase.table("respuestas_formulario").select("*", count="exact", head=True).execute()
    total = getattr(total_resp, "count", None) or 0

    # Traer satisfacciones para promedio
    rows = supabase.table("respuestas_formulario").select("satisfaccion, categoria").execute().data or []

    # Promedio global
    vals = [r.get("satisfaccion") or 0 for r in rows if r.get("satisfaccion") is not None]
    promedio = round(sum(vals) / len(vals), 2) if vals else 0.0

    # Agregación por categoría
    agg = {}
    for r in rows:
        cat = r.get("categoria") or "Sin categoría"
        sat = r.get("satisfaccion") or 0
        if cat not in agg:
            agg[cat] = {"total": 0, "sum": 0}
        agg[cat]["total"] += 1
        agg[cat]["sum"] += sat

    categorias = [
        {
            "categoria": cat,
            "total_respuestas": v["total"],
            "promedio_satisfaccion": round(v["sum"]/v["total"], 2) if v["total"] else 0.0
        }
        for cat, v in agg.items()
    ]

    return {
        "global": {"total": total, "promedio": promedio},
        "categorias": categorias
    }
