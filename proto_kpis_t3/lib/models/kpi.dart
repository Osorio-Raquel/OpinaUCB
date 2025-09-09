// lib/models/kpi.dart
class KPIGlobal {
  final int total;
  final double promedio;
  KPIGlobal({required this.total, required this.promedio});

  factory KPIGlobal.fromMap(Map<String, dynamic> m) {
    return KPIGlobal(
      total: (m['total'] as num?)?.toInt() ?? 0,
      promedio: ((m['promedio'] as num?) ?? 0).toDouble(),
    );
  }
}

class KPICategoria {
  final String categoria;
  final int totalRespuestas;
  final double promedioSatisfaccion;
  KPICategoria({
    required this.categoria,
    required this.totalRespuestas,
    required this.promedioSatisfaccion,
  });

  factory KPICategoria.fromMap(Map<String, dynamic> m) {
    return KPICategoria(
      categoria: (m['categoria'] as String?) ?? 'Sin categoría',
      totalRespuestas: (m['total_respuestas'] as num?)?.toInt() ?? 0,
      promedioSatisfaccion: ((m['promedio_satisfaccion'] as num?) ?? 0).toDouble(),
    );
  }
}

class KPIsBundle {
  final KPIGlobal global;
  final List<KPICategoria> categorias;
  KPIsBundle({required this.global, required this.categorias});

  factory KPIsBundle.fromMap(Map<String, dynamic> m) {
    return KPIsBundle(
      global: KPIGlobal.fromMap(m['global'] ?? {}),
      categorias: ((m['categorias'] as List?) ?? [])
          .map((e) => KPICategoria.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
