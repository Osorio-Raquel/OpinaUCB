import 'package:supabase/supabase.dart';
import 'package:postgrest/postgrest.dart'; // para PostgrestException
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
  }) {
    if (satisfaccion < 1 || satisfaccion > 5) {
      throw ArgumentError('satisfaccion debe estar entre 1 y 5');
    }
  }

  factory FormularioInput.fromMap(Map<String, dynamic> m) {
    void req(bool cond, String msg) { if (!cond) throw ArgumentError(msg); }
    req(m['categoria'] != null, 'categoria requerida');
    req(m['satisfaccion'] is int, 'satisfaccion requerida (int 1..5)');

    return FormularioInput(
      usuarioId: m['usuario_id'] as String?,
      edad: m['edad'] as int?,
      genero: m['genero'] as String?,
      ciudad: m['ciudad'] as String?,
      categoria: m['categoria'] as String,
      satisfaccion: m['satisfaccion'] as int,
      calidadServicio: m['calidad_servicio'] as int?,
      recomendar: m['recomendar'] as String?,
      comentario: m['comentario'] as String?,
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
  try {
    // Inserta; si hay error, supabase lanzará PostgrestException
    await supabase.from('respuestas_formulario').insert(input.toRow());

    // Si quisieras el registro insertado, usa:
    // final inserted = await supabase
    //   .from('respuestas_formulario')
    //   .insert(input.toRow())
    //   .select()
    //   .single();
    // print(inserted);
  } on PostgrestException catch (e) {
    // error legible de la API
    throw Exception('Supabase insert error: ${e.message}');
  } catch (e) {
    // otros errores (parseo, red, etc.)
    rethrow;
  }
}
