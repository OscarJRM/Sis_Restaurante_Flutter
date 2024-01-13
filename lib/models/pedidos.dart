import 'package:postgres/postgres.dart';
import '../BaseDatos/conexion.dart';

class Pedido {
  int idPed;
  DateTime fecHorPed;
  String totPed;
  String cedEmpAti;
  String numMesPid;
  String idEstPed;

  Pedido({
    required this.idPed,
    required this.fecHorPed,
    required this.totPed,
    required this.cedEmpAti,
    required this.numMesPid,
    required this.idEstPed,
  });

  void cargarPedido() async{
    final conn = await DatabaseConnection.instance.openConnection();
    final result = await conn.execute("SELECT * from MAESTRO_PEDIDOS where CED_EMP_ATI=\$1", parameters: ["1850464338"]);
    List<Pedido> listaPedidos = cargarPedidos(result);
    await conn.close();
  }
}

List<Pedido> cargarPedidos(Result result) {
  return result.map((row) {
    return Pedido(
      idPed: row[0] as int,
      fecHorPed: row[1] as DateTime,
      totPed: row[2] as String,
      cedEmpAti: row[3] as String,
      numMesPid: row[4] as String,
      idEstPed: row[5] as String,
    );
  }).toList();
}

void main() async {
  final conn = await DatabaseConnection.instance.openConnection();
  List<ResultRow> Lista =[];

  /*final resultPedidos1 = await conn.execute("SELECT * from MAESTRO_PEDIDOS");

  // Imprimir la lista de pedidos
  resultPedidos1.forEach((row) {
    print(
        'ID: ${row[0]}, Fecha/Hora: ${row[1]}, Total: ${row[2]}, Cédula Empleado: ${row[3]}, Número Mesa: ${row[4]}, ID Estado: ${row[5]}');
  });
  
  final resultdele = await conn.execute(
  'DELETE FROM MAESTRO_PEDIDOS WHERE ID_PED = \$1',
  parameters: [10],
);*/
  final result = await conn
      .execute("SELECT * from Productos where ID_PRO=\$1", parameters: [1]);
  Lista = result;
print('Valor de la columna 3: ${Lista.isNotEmpty ? Lista[0][4] : "Lista vacía"}');
  Lista.forEach((row) {
    print(
        'ID: ${row[0]}, Fecha/Hora: ${row[1]}, Total: ${row[2]}, Cédula Empleado: ${row[3]}, Número Mesa: ${row[4]}');
  });
  try {
    final results1 = await conn.execute('SELECT * FROM ESTADOS_PEDIDO');

    // Imprime los resultados
    results1.forEach((row) {
      print('Número de Mesa: ${row[0]}, Estado: ${row[1]}');
    });
  } catch (e) {
    print('Error al realizar la consulta: $e');
  }

  final results = await conn.execute('SELECT * FROM EMPLEADOS');

  // Imprime los resultados
  results.forEach((row) {
    print(
        'Cédula: ${row[0]}, Nombre: ${row[1]}, Apellido: ${row[2]}, Usuario: ${row[3]}, Contraseña: ${row[4]}, Tipo: ${row[5]}');
  });

  // Cargar datos de la tabla PEDIDOS
  final resultPedidos = await conn.execute(
      'SELECT * from MAESTRO_PEDIDOS where CED_EMP_ATI=\$1',
      parameters: ["1850464338"]);
  List<Pedido> listaPedidos = cargarPedidos(resultPedidos);

  // Imprimir la lista de pedidos
  listaPedidos.forEach((pedido) {
    print(
        'ID: ${pedido.idPed}, Fecha/Hora: ${pedido.fecHorPed}, Total: ${pedido.totPed}, Cédula Empleado: ${pedido.cedEmpAti}, Número Mesa: ${pedido.numMesPid}, ID Estado: ${pedido.idEstPed}');
  });

  // Cierra la conexión cuando hayas terminado de usarla
  await conn.close();
}
