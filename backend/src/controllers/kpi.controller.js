import { kpiGlobal, kpiPorCategoria } from '../services/kpi.service.js';

export async function obtenerKPIs(_req, res) {
  try {
    const [global, categorias] = await Promise.all([kpiGlobal(), kpiPorCategoria()]);
    res.json({ global, categorias });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'No se pudieron calcular las KPIs' });
  }
}
