import supabase from '../config/supabase.js';

export async function kpiGlobal() {
  // COUNT exacto
  const { count, error: countErr } = await supabase
    .from('respuestas_formulario')
    .select('*', { count: 'exact', head: true });
  if (countErr) throw countErr;

  // AVG de satisfaccion (simple para claridad)
  const { data, error } = await supabase
    .from('respuestas_formulario')
    .select('satisfaccion');
  if (error) throw error;

  const valores = (data || []).map(r => r.satisfaccion || 0);
  const promedio = valores.length ? (valores.reduce((a,b) => a+b, 0) / valores.length) : 0;

  return { total: count || 0, promedio: Number(promedio.toFixed(2)) };
}

export async function kpiPorCategoria() {
  const { data, error } = await supabase
    .from('respuestas_formulario')
    .select('categoria, satisfaccion');
  if (error) throw error;

  const agg = {};
  for (const r of (data || [])) {
    const cat = r.categoria || 'Sin categoría';
    if (!agg[cat]) agg[cat] = { total: 0, sum: 0 };
    agg[cat].total += 1;
    agg[cat].sum += r.satisfaccion || 0;
  }

  return Object.entries(agg).map(([categoria, v]) => ({
    categoria,
    total_respuestas: v.total,
    promedio_satisfaccion: Number((v.sum / v.total).toFixed(2))
  }));
}
