import 'package:flutter/material.dart';
import '../services/experiencia_service.dart';

/// Valores EXACTOS según tu CHECK de Postgres (con acentos)
const opcionesTutorias = [
  'Muy útiles', 'Útiles', 'Regulares', 'Poco útiles', 'Nada útiles',
];
const opcionesOrientacion = [
  'Muy accesibles', 'Accesibles', 'Regulares', 'Poco accesibles', 'Nada accesibles',
];
const opcionesSatisfaccion = [
  'Muy satisfecho', 'Satisfecho', 'Neutral', 'Insatisfecho', 'Muy insatisfecho',
];
const opcionesCalidad = [
  'Excelente', 'Bueno', 'Regular', 'Deficiente', 'Muy deficiente',
];
const opcionesAdecuacion = [
  'Muy adecuada', 'Adecuada', 'Regular', 'Poco adecuada', 'Nada adecuada',
];

class ExperienciaFormScreen extends StatefulWidget {
  final ExperienciaService servicio;
  const ExperienciaFormScreen({super.key, required this.servicio});

  @override
  State<ExperienciaFormScreen> createState() => _ExperienciaFormScreenState();
}

class _ExperienciaFormScreenState extends State<ExperienciaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? p1, p2, p3, p4, p5, p6;
  final TextEditingController _sugerenciasCtrl = TextEditingController();
  bool _enviando = false;
  String? _error;

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _enviando = true; _error = null; });

    final resp = await widget.servicio.createRespuesta(
      pregunta1Tutorias: p1!,
      pregunta2Orientacion: p2!,
      pregunta3Extracurriculares: p3!,
      pregunta4ApoyoDesarrollo: p4!,
      pregunta5Comunicacion: p5!,
      pregunta6SatisfaccionGeneral: p6!,
      pregunta7Sugerencias: _sugerenciasCtrl.text,
    );

    if (!mounted) return;
    setState(() => _enviando = false);

    if (resp['success'] == true) {
      await showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('¡Gracias!'),
          content: Text('Tu respuesta fue registrada correctamente.'),
        ),
      );
      _formKey.currentState!.reset();
      setState(() { p1=p2=p3=p4=p5=p6=null; _sugerenciasCtrl.clear(); });
    } else {
      setState(() => _error = resp['message'] ?? 'Error al enviar');
    }
  }

  Widget _select(String label, List<String> items, String? value, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => (v == null || v.isEmpty) ? 'Seleccione una opción' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiencia y Apoyo al Estudiante'),
        backgroundColor: Colors.red[700], foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AbsorbPointer(
          absorbing: _enviando,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _select(
                  '1) ¿Qué tan útiles han sido las tutorías académicas para ti?',
                  opcionesTutorias, p1, (v)=>setState(()=>p1=v),
                ),
                const SizedBox(height: 14),
                _select(
                  '2) ¿Cómo calificas el acceso a los servicios de orientación estudiantil?',
                  opcionesOrientacion, p2, (v)=>setState(()=>p2=v),
                ),
                const SizedBox(height: 14),
                _select(
                  '3) ¿Qué tan satisfecho(a) estás con la calidad de las actividades extracurriculares ofrecidas?',
                  opcionesSatisfaccion, p3, (v)=>setState(()=>p3=v),
                ),
                const SizedBox(height: 14),
                _select(
                  '4) ¿Cómo evalúas el apoyo de la institución a tu desarrollo personal y profesional?',
                  opcionesCalidad, p4, (v)=>setState(()=>p4=v),
                ),
                const SizedBox(height: 14),
                _select(
                  '5) ¿Qué tan adecuada consideras la comunicación de la universidad con los estudiantes?',
                  opcionesAdecuacion, p5, (v)=>setState(()=>p5=v),
                ),
                const SizedBox(height: 14),
                _select(
                  '6) Nivel general de satisfacción con la experiencia y apoyo al estudiante:',
                  opcionesSatisfaccion, p6, (v)=>setState(()=>p6=v),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _sugerenciasCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: '7) (Pregunta abierta) ¿Qué sugerencias tienes para mejorar la experiencia y apoyo al estudiante?',
                    hintText: 'Escribe tus sugerencias…',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline, color: Color(0xFFD32F2F), size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_error!, style: const TextStyle(color: Color(0xFFD32F2F)))),
                    ]),
                  ),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _enviando ? null : _enviar,
                    icon: _enviando
                        ? const SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send),
                    label: Text(_enviando ? 'Enviando...' : 'Enviar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700], foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
