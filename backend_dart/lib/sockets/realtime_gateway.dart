import 'package:socket_io/socket_io.dart';
import '../services/kpi_service.dart';

late Server io;

void initRealtime(Server server) {
  io = server;

  io.on('connection', (client) async {
    try {
      final kpis = await obtenerKPIs();
      client.emit('metric:update', kpis);
    } catch (e) {
      // loguea si quieres
    }
  });
}

Future<void> emitirKPIsInstantaneo() async {
  try {
    final kpis = await obtenerKPIs();
    io.emit('metric:update', kpis);
  } catch (_) {}
}
