import 'package:shelf_router/shelf_router.dart';
import '../controllers/kpi_controller.dart';

Router buildKpiRouter() {
  final r = Router();
  r.get('/', obtenerKPIsController);
 
  return r;
}

