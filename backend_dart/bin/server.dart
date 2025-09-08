import 'dart:io';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io_shelf;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:socket_io/socket_io.dart';

import '../lib/config/supabase.dart';
import '../lib/routes/formulario_routes.dart';
import '../lib/routes/kpi_routes.dart';
import '../lib/sockets/realtime_gateway.dart';

Future<void> main() async {
  // logs
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((r) => print('${r.level.name}: ${r.time}: ${r.message}'));

  // config & supabase
  initConfig();

  // Router HTTP
  final router = Router()
    ..get('/health', (Request _) => Response.ok('{"ok":true}', headers: {'Content-Type':'application/json'}))
    ..mount('/api/formulario', buildFormularioRouter())
    ..mount('/api/kpis', buildKpiRouter());

  // Middlewares: CORS + JSON
  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders(
        headers: {
          ACCESS_CONTROL_ALLOW_ORIGIN: corsOrigin,
          ACCESS_CONTROL_ALLOW_HEADERS: 'Origin, Content-Type, Accept',
          ACCESS_CONTROL_ALLOW_METHODS: 'GET, POST, OPTIONS',
        },
      ))
      .addHandler(router);

  // Un solo HttpServer para HTTP + Socket.IO
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('HTTP + WS escuchando en http://0.0.0.0:$port');

  // Socket.IO (path fijo para Flutter)
  final sio = Server();
  // MUY IMPORTANTE: path '/socket.io/' para que coincida con Flutter
  sio.attach(server, <String, dynamic>{'path': '/socket.io/'});
  initRealtime(sio);

  // Atiende requests de Shelf en el mismo server
  io_shelf.serveRequests(server, pipeline);
}
