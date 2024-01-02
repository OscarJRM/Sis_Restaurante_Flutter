import 'package:postgres/postgres.dart';
import '../BaseDatos/conexion.dart';

class DetallePedido {
  int idPedPer;
  String idProPed;
  String estProPed;
  String canProPed;

  DetallePedido({
    required this.idPedPer,
    required this.idProPed,
    required this.estProPed,
    required this.canProPed,
  });
}

List<DetallePedido> cargarDetallePedidos(Result result) {
  return result.map((row) {
    return DetallePedido(
        idPedPer: row[0] as int,
        idProPed: row[1] as String,
        estProPed: row[2] as String,
        canProPed: row[3] as String);
  }).toList();
}

void main() async {
  final conn = await DatabaseConnection.openConnection();

  // Utiliza query en lugar de execute para obtener un resultado
  // Utiliza query en lugar de prepare y run para obtener un resultado
  final result = await conn.execute("SELECT * from DETALLE_PEDIDOS");

  // Llena la lista de mesas con los resultados obtenidos
  List<DetallePedido> listaDetallePedido = cargarDetallePedidos(result);

  // Imprime la lista de mesas
  listaDetallePedido.forEach((detalle) {
    print(
        '  Detalle - ID: ${detalle.idPedPer}, Producto: ${detalle.idProPed}, Cantidad: ${detalle.canProPed}');
  });

  // Cierra la conexión cuando hayas terminado de usarla
  await conn.close();
}
