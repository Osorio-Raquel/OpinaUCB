import 'package:supabase/supabase.dart';
import '../config/supabase.dart';

class FormularioInput {
  final String? usuarioId;
  final int? edad;
  final String? genero;
  final String? ciudad;
  final String categoria;        // requerido
  final int satisfaccion;        // 1..5 requerido
  final int? calidadServicio;
  final String? recomendar;
  final String? comentario;

  FormularioInput({
    this.usuarioId,
    this.edad,
    this.genero,
    this.ciudad,
    required this.categoria,
    required this.satisfaccion,
    this.calidadServicio,
    this.recomendar,
    this.comentario,
  });

  factory FormularioInput.fromMap(Map<String, dynamic> m) {
    void req(bool cond, String msg) { if (!cond) throw ArgumentError(msg); }
    req(m['categoria'] != null, 'categoria requerida');
    req(m['satisfaccion'] is int, 'satisfaccion requerida (int 1..5)');
    return FormularioInput(
      usuarioId: m['usuario_id'],
      edad: m['edad'],
      genero: m['genero'],
      ciudad: m['ciudad'],
      categoria: m['categoria'],
      satisfaccion: m['satisfaccion'],
      calidadServicio: m['calidad_servicio'],
      recomendar: m['recomendar'],
      comentario: m['comentario'],
    );
  }

  Map<String, dynamic> toRow() => {
    'usuario_id': usuarioId,
    'edad': edad,
    'genero': genero,
    'ciudad': ciudad,
    'categoria': categoria,
    'satisfaccion': satisfaccion,
    'calidad_servicio': calidadServicio,
    'recomendar': recomendar,
    'comentario': comentario,
  };
}

Future<void> insertarRespuesta(FormularioInput input) async {
  final res = await supabase.from('respuestas_formulario').insert(input.toRow());
  final error = (res as PostgrestResponse).error;
  if (error != null) throw error;
}
