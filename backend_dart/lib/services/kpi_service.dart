import '../config/supabase.dart';

class KPIGlobal {
  final int total;
  final double promedio;
  KPIGlobal(this.total, this.promedio);

  Map<String, dynamic> toJson() => {
    'total': total,
    'promedio': double.parse(promedio.toStringAsFixed(2)),
  };
}

class KPICategoria {
  final String categoria;
  final int totalRespuestas;
  final double promedioSatisfaccion;
  KPICategoria(this.categoria, this.totalRespuestas, this.promedioSatisfaccion);

  Map<String, dynamic> toJson() => {
    'categoria': categoria,
    'total_respuestas': totalRespuestas,
    'promedio_satisfaccion': double.parse(promedioSatisfaccion.toStringAsFixed(2)),
  };
}

Future<Map<String, dynamic>> obtenerKPIs() async {
  // Count exacto (head=true no existe aquí; hacemos select y contamos)
  final rows = await supabase.from('respuestas_formulario')
      .select('satisfaccion,categoria') as List<dynamic>;

  final total = rows.length;
  final satisf = <int>[];
  final agg = <String, Map<String, num>>{}; // { cat: {total, sum} }

  for (final r in rows) {
    final m = (r as Map<String, dynamic>);
    final cat = (m['categoria'] as String?) ?? 'Sin categoría';
    final sat = (m['satisfaccion'] as int?) ?? 0;
    satisf.add(sat);

    agg.putIfAbsent(cat, () => {'total': 0, 'sum': 0});
    agg[cat]!['total'] = (agg[cat]!['total']! + 1);
    agg[cat]!['sum'] = (agg[cat]!['sum']! + sat);
  }

  final promedio = satisf.isEmpty
      ? 0.0
      : satisf.reduce((a, b) => a + b) / satisf.length;

  final categorias = agg.entries.map((e) {
    final totalCat = e.value['total']!.toInt();
    final promCat = totalCat == 0 ? 0.0 : (e.value['sum']! / totalCat);
    return KPICategoria(e.key, totalCat, promCat).toJson();
  }).toList();

  return {
    'global': KPIGlobal(total, promedio).toJson(),
    'categorias': categorias,
  };
}
