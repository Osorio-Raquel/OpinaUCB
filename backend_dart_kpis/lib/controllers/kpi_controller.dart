import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/kpi_service.dart';

Future<Response> obtenerKPIsController(Request req) async {
  try {
    final kpis = await obtenerKPIs();
    return Response.ok(jsonEncode(kpis),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'No se pudieron calcular las KPIs'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
