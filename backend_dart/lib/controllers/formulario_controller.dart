import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/formulario_service.dart';
import '../sockets/realtime_gateway.dart';

Future<Response> crearRespuesta(Request req) async {
  try {
    final body = await req.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final input = FormularioInput.fromMap(data);

    await insertarRespuesta(input);
    await emitirKPIsInstantaneo();

    return Response.ok(jsonEncode({'ok': true}),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'No se pudo guardar la respuesta', 'detalle': e.toString()}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
