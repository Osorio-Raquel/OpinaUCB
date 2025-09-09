import 'package:flutter/material.dart';
import 'models/kpi.dart';
import 'services/api_service.dart';
import 'services/realtime_service.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const ProtoApp());
}

class ProtoApp extends StatelessWidget {
  const ProtoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prototipo KPIs T1',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomeTabs(),
    );
  }
}

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});
  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> with TickerProviderStateMixin {
  late final TabController _controller;
  final rt = RealtimeService();
  KPIsBundle? _kpis;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);

    // Conectar WS y escuchar KPIs
    rt.connect(onKPIs: (k) {
      setState(() => _kpis = k);
    });

    // Cargar fallback inicial por HTTP (en caso de que el WS tarde)
    ApiService().getKPIs().then((k) {
      if (mounted && _kpis == null && k != null) setState(() => _kpis = k);
    });
  }

  @override
  void dispose() {
    rt.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const Tab(text: 'Formulario'),
      const Tab(text: 'Dashboard'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarea 1: Flutter + Node + Supabase'),
        bottom: TabBar(controller: _controller, tabs: tabs),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          FormularioScreen(
            onSubmitted: () async {
              // Al enviar, el backend emite nuevas KPIs por WS automáticamente
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enviado')),
              );
            },
          ),
          DashboardScreen(kpis: _kpis),
        ],
      ),
    );
  }
}

class FormularioScreen extends StatefulWidget {
  final VoidCallback? onSubmitted;
  const FormularioScreen({super.key, this.onSubmitted});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categorias = const ['Docentes', 'Infraestructura', 'Servicios', 'Administración'];
  String _categoria = 'Docentes';
  int _satisfaccion = 3;
  String? _comentario;
  String? _genero;
  String? _ciudad;
  int? _edad;
  String? _recomendar;

  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _loading = true);

    final ok = await ApiService().enviarFormulario(
      categoria: _categoria,
      satisfaccion: _satisfaccion,
      comentario: _comentario,
      genero: _genero,
      ciudad: _ciudad,
      edad: _edad,
      recomendar: _recomendar,
      calidadServicio: null, // si quieres lo puedes pedir también
    );

    setState(() => _loading = false);
    if (ok) {
      widget.onSubmitted?.call();
      _formKey.currentState!.reset();
      setState(() {
        _categoria = 'Docentes';
        _satisfaccion = 3;
        _comentario = null;
        _genero = null;
        _ciudad = null;
        _edad = null;
        _recomendar = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = 12.0;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _categoria,
              decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()),
              items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _categoria = v ?? _categoria),
            ),
            SizedBox(height: spacing),
            InputDecorator(
              decoration: const InputDecoration(labelText: 'Satisfacción (1–5)', border: OutlineInputBorder()),
              child: Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _satisfaccion.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$_satisfaccion',
                      onChanged: (v) => setState(() => _satisfaccion = v.toInt()),
                    ),
                  ),
                  Text('$_satisfaccion'),
                ],
              ),
            ),
            SizedBox(height: spacing),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Comentario (opcional)', border: OutlineInputBorder()),
              maxLines: 3,
              onSaved: (v) => _comentario = (v?.trim().isEmpty ?? true) ? null : v!.trim(),
            ),
            SizedBox(height: spacing),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Ciudad (opcional)', border: OutlineInputBorder()),
              onSaved: (v) => _ciudad = (v?.trim().isEmpty ?? true) ? null : v!.trim(),
            ),
            SizedBox(height: spacing),
            DropdownButtonFormField<String>(
              value: _genero,
              decoration: const InputDecoration(labelText: 'Género (opcional)', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                DropdownMenuItem(value: 'Otro', child: Text('Otro')),
              ],
              onChanged: (v) => setState(() => _genero = v),
            ),
            SizedBox(height: spacing),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Edad (opcional)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onSaved: (v) {
                final t = v?.trim();
                _edad = (t == null || t.isEmpty) ? null : int.tryParse(t);
              },
            ),
            SizedBox(height: spacing),
            DropdownButtonFormField<String>(
              value: _recomendar,
              decoration: const InputDecoration(labelText: '¿Recomendaría? (opcional)', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Sí', child: Text('Sí')),
                DropdownMenuItem(value: 'No', child: Text('No')),
              ],
              onChanged: (v) => setState(() => _recomendar = v),
            ),
            SizedBox(height: spacing),
            FilledButton.icon(
              onPressed: _loading ? null : _submit,
              icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
              label: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final KPIsBundle? kpis;
  const DashboardScreen({super.key, this.kpis});

  @override
  Widget build(BuildContext context) {
    if (kpis == null) {
      return const Center(child: Text('Cargando KPIs...'));
    }

    final g = kpis!.global;
    final cats = kpis!.categorias;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('KPIs en tiempo real', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _KpiCard(title: 'Total respuestas', value: '${g.total}')),
            const SizedBox(width: 12),
            Expanded(child: _KpiCard(title: 'Promedio global', value: g.promedio.toStringAsFixed(2))),
          ],
        ),
        const SizedBox(height: 24),
        Text('Promedio por categoría', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= cats.length) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          cats[i].categoria,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              barGroups: List.generate(cats.length, (i) {
                final y = cats[i].promedioSatisfaccion;
                return BarChartGroupData(
                  x: i,
                  barRods: [BarChartRodData(toY: y, width: 18)],
                );
              }),
              minY: 0,
              maxY: 5,
            ),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  const _KpiCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
