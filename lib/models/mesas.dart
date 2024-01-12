import 'package:postgres/postgres.dart';
import '../BaseDatos/conexion.dart';

class Mesa {
  String numMes;
  String estMes;

  Mesa({
    required this.numMes,
    required this.estMes,
  });
}

List<Mesa> cargarMesas(Result result) {
  return result.map((row) {
    return Mesa(
      numMes: row[0] as String,
      estMes: row[1] as String,
    );
  }).toList();
}

void main() async {
  final conn = await DatabaseConnection.instance.openConnection();
  final result1 = await conn.execute(
    r'INSERT INTO MESAS VALUES (7,$1)',
    parameters: ["DISPONIBLE"]
  );


  // Utiliza query en lugar de execute para obtener un resultado
  // Utiliza query en lugar de prepare y run para obtener un resultado
  final result = await conn.execute("SELECT * FROM MESAS");

  // Llena la lista de mesas con los resultados obtenidos
  List<Mesa> listaMesas = cargarMesas(result);

  // Imprime la lista de mesas
  listaMesas.forEach((mesa) {
    print('Número de Mesa: ${mesa.numMes}, Estado: ${mesa.estMes}');
  });

  // Cierra la conexión cuando hayas terminado de usarla
  await conn.close();
}