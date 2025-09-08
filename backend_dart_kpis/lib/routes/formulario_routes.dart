import 'package:shelf_router/shelf_router.dart';
import '../controllers/formulario_controller.dart';

Router buildFormularioRouter() {
  final r = Router();
  // con slash
  r.post('/', crearRespuesta);
  // sin slash (aceptamos ambos para evitar 307)
 
  return r;
}
