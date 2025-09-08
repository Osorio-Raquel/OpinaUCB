import 'dart:io';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:socket_io/socket_io.dart' as sio;

import 'package:backend_dart_kpis/config/supabase.dart';
import 'package:backend_dart_kpis/routes/formulario_routes.dart';
import 'package:backend_dart_kpis/routes/kpi_routes.dart';
import 'package:backend_dart_kpis/sockets/realtime_gateway.dart';

Future<void> main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((r) => print('${r.level.name}: ${r.time}: ${r.message}'));

  initConfig();

  final router = Router()
    ..get('/health', (Request _) => Response.ok('{"ok":true}', headers: {'Content-Type':'application/json'}))
    ..mount('/api/formulario', buildFormularioRouter())
    ..mount('/api/kpis', buildKpiRouter());

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders(headers: {
        ACCESS_CONTROL_ALLOW_ORIGIN: corsOrigin,
        ACCESS_CONTROL_ALLOW_HEADERS: 'Origin, Content-Type, Accept',
        ACCESS_CONTROL_ALLOW_METHODS: 'GET, POST, OPTIONS',
      }))
      .addHandler(router);

  // 1) Levanta Shelf y espera el HttpServer
  final httpServer = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    port,
    poweredByHeader: null, // opcional, quita 'shelf'
  );
  print('HTTP escuchando en http://0.0.0.0:$port');

  // 2) Adjunta Socket.IO al mismo server y path fijo
  final sioServer = sio.Server();
  sioServer.attach(httpServer, {'path': '/socket.io/'});
  initRealtime(sioServer);

  print('WS listo en /socket.io/');
}
