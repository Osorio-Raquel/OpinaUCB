// lib/screens/calidad_academica_form_screen.dart
import 'package:flutter/material.dart';
import '../services/calidad_academica_service.dart';

/// Opciones EXACTAS según tu tabla (no tocar)
const opcionesClaridad = [
  'Muy claro','Claro','Regular','Poco claro','Nada claro',
];
const opcionesEval5 = [
  'Excelente','Buena','Regular','Deficiente','Muy deficiente',
];
const opcionesAdecuacion = [
  'Muy adecuados','Adecuados','Regulares','Poco adecuados','Nada adecuados',
];
const opcionesCarga = [
  'Muy adecuada','Adecuada','Regular','Excesiva','Insuficiente',
];
const opcionesFlex = [
  'Muy flexible','Flexible','Regular','Poco flexible','Nada flexible',
];
const opcionesSatisfaccion = [
  'Muy satisfecho','Satisfecho','Neutral','Insatisfecho','Muy insatisfecho',
];

class CalidadAcademicaFormScreen extends StatefulWidget {
  final CalidadAcademicaService servicio;
  const CalidadAcademicaFormScreen({super.key, required this.servicio});

  @override
  State<CalidadAcademicaFormScreen> createState() => _CalidadAcademicaFormScreenState();
}

class _CalidadAcademicaFormScreenState extends State<CalidadAcademicaFormScreen> {
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
      pregunta1Claridad: p1!,
      pregunta2PreparacionDocentes: p2!,
      pregunta3MetodosEnsenanza: p3!,
      pregunta4CargaHoraria: p4!,
      pregunta5ProgramacionHorarios: p5!,
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
      setState(() { p1=p2=p3=p4=p5=p6=null; _sugerenciasCtrl.clear(); });
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
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16.5, fontWeight: FontWeight.w600, height: 1.35, color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: valor,
              isExpanded: true,
              items: opciones
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e, softWrap: true, overflow: TextOverflow.visible),
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
              '7) (Pregunta abierta) ¿Qué sugerencias tienes para mejorar la calidad académica?',
              style: TextStyle(
                fontSize: 16.5, fontWeight: FontWeight.w600, height: 1.35, color: Color(0xFF2D2D2D),
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
        title: const Text('Calidad Académica'),
        backgroundColor: themeRed,
        foregroundColor: Colors.white,
      ),
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
                backgroundColor: themeRed, foregroundColor: Colors.white,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: LayoutBuilder(
            builder: (context, c) {
              final maxW = c.maxWidth > 720 ? 720.0 : c.maxWidth;
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    children: [
                      Card(
                        color: Colors.red[50],
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.school, color: themeRed),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Evalúa claridad, preparación docente, métodos, carga y horarios. '
                                  'Tus respuestas son confidenciales.',
                                  style: TextStyle(
                                    color: Colors.red[900], fontSize: 14.5, height: 1.35,
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
                              Expanded(child: Text(_error!, style: const TextStyle(color: Color(0xFFD32F2F)))),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),

                      _questionCard(
                        titulo: '1) Claridad en la explicación de contenidos por parte de los docentes:',
                        opciones: opcionesClaridad,
                        valor: p1,
                        onChanged: (v) => setState(() => p1 = v),
                      ),
                      _questionCard(
                        titulo: '2) Preparación y dominio de los contenidos por parte de los docentes:',
                        opciones: opcionesEval5,
                        valor: p2,
                        onChanged: (v) => setState(() => p2 = v),
                      ),
                      _questionCard(
                        titulo: '3) Métodos de enseñanza utilizados por los docentes:',
                        opciones: opcionesAdecuacion,
                        valor: p3,
                        onChanged: (v) => setState(() => p3 = v),
                      ),
                      _questionCard(
                        titulo: '4) Carga horaria en relación con las exigencias del curso:',
                        opciones: opcionesCarga,
                        valor: p4,
                        onChanged: (v) => setState(() => p4 = v),
                      ),
                      _questionCard(
                        titulo: '5) Programación y flexibilidad de horarios:',
                        opciones: opcionesFlex,
                        valor: p5,
                        onChanged: (v) => setState(() => p5 = v),
                      ),
                      _questionCard(
                        titulo: '6) Satisfacción general con la calidad académica:',
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
