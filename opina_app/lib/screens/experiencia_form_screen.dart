import 'package:flutter/material.dart';
import '../services/experiencia_service.dart';

/// Valores EXACTOS (no tocar)
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
  final _sugerenciasCtrl = TextEditingController();
  bool _enviando = false;
  String? _error;

  @override
  void dispose() {
    _sugerenciasCtrl.dispose();
    super.dispose();
  }

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Respuesta registrada. ¡Gracias!')),
        );
      }
      _formKey.currentState!.reset();
      setState(() { p1 = p2 = p3 = p4 = p5 = p6 = null; _sugerenciasCtrl.clear(); });
      Navigator.of(context).maybePop();
    } else {
      setState(() => _error = resp['message'] ?? 'Error al enviar');
    }
  }

  Widget _questionCard({
    required String titulo,
    required List<String> opciones,
    required String? valor,
    required void Function(String?) onChanged,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la pregunta (full width, multi-line)
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 12),
            // Selector
            DropdownButtonFormField<String>(
              value: valor,
              isExpanded: true, // 👈 evita cortes/overflow
              items: opciones
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ))
                  .toList(),
              onChanged: onChanged,
              validator: (v) => (v == null || v.isEmpty) ? 'Seleccione una opción' : null,
              decoration: InputDecoration(
                hintText: 'Selecciona una opción',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sugerenciasCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '7) (Pregunta abierta) ¿Qué sugerencias tienes para mejorar la experiencia y apoyo al estudiante?',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sugerenciasCtrl,
              maxLines: 5,
              minLines: 3,
              decoration: InputDecoration(
                hintText: 'Escribe tus sugerencias…',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_sugerenciasCtrl.text.length}/500',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeRed = Colors.red[700];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiencia y Apoyo al Estudiante'),
        backgroundColor: themeRed,
        foregroundColor: Colors.white,
      ),
      // Botón fijo abajo
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _enviando ? null : _enviar,
              icon: _enviando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send),
              label: Text(_enviando ? 'Enviando...' : 'Enviar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 3,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // 👈 validación “en vivo”
          child: LayoutBuilder(
            builder: (context, c) {
              // ancho máximo para evitar líneas demasiado largas en tablets/web
              final maxW = c.maxWidth > 720 ? 720.0 : c.maxWidth;
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96), // deja espacio al botón
                    children: [
                      // Encabezado
                      Card(
                        color: Colors.red[50],
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.people_alt, color: themeRed),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Responde las siguientes preguntas sobre tu experiencia y el apoyo al estudiante. '
                                  'Tus respuestas son confidenciales.',
                                  style: TextStyle(
                                    color: Colors.red[900],
                                    fontSize: 14.5,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE57373)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.error_outline, color: Color(0xFFD32F2F), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _error!,
                                  style: const TextStyle(color: Color(0xFFD32F2F)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),
                      _questionCard(
                        titulo: '1) ¿Qué tan útiles han sido las tutorías académicas para ti?',
                        opciones: opcionesTutorias,
                        valor: p1,
                        onChanged: (v) => setState(() => p1 = v),
                      ),
                      _questionCard(
                        titulo: '2) ¿Cómo calificas el acceso a los servicios de orientación estudiantil?',
                        opciones: opcionesOrientacion,
                        valor: p2,
                        onChanged: (v) => setState(() => p2 = v),
                      ),
                      _questionCard(
                        titulo: '3) ¿Qué tan satisfecho(a) estás con la calidad de las actividades extracurriculares ofrecidas?',
                        opciones: opcionesSatisfaccion,
                        valor: p3,
                        onChanged: (v) => setState(() => p3 = v),
                      ),
                      _questionCard(
                        titulo: '4) ¿Cómo evalúas el apoyo de la institución a tu desarrollo personal y profesional?',
                        opciones: opcionesCalidad,
                        valor: p4,
                        onChanged: (v) => setState(() => p4 = v),
                      ),
                      _questionCard(
                        titulo: '5) ¿Qué tan adecuada consideras la comunicación de la universidad con los estudiantes?',
                        opciones: opcionesAdecuacion,
                        valor: p5,
                        onChanged: (v) => setState(() => p5 = v),
                      ),
                      _questionCard(
                        titulo: '6) Nivel general de satisfacción con la experiencia y apoyo al estudiante:',
                        opciones: opcionesSatisfaccion,
                        valor: p6,
                        onChanged: (v) => setState(() => p6 = v),
                      ),
                      _sugerenciasCard(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
