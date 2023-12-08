import 'package:postgres/postgres.dart';
import '../BaseDatos/conexion.dart';

class Plato {
  String idPro;
  String nomPro;
  String preUni; // Cambiado a double
  String urlImg;
  String idCatPer;

  Plato({
    required this.idPro,
    required this.nomPro,
    required this.preUni,
    required this.urlImg,
    required this.idCatPer,
  });
}
  
List<Plato> platos(Result result) {
  return result.map((row) {
    return Plato(
      idPro: row[0] as String,
      preUni: row[2] as String,
      nomPro: row[3] as String, // Cambiado a double
      idCatPer: row[4] as String,
      urlImg: row[5] as String,
    );
  }).toList();
}

void main() async {
  final conn = await DatabaseConnection.openConnection();

  // Utiliza query en lugar de execute para obtener un resultado
  // Utiliza query en lugar de prepare y run para obtener un resultado
  final result = await conn.execute("SELECT * from Productos");

  // Llena la lista de platos con los resultados obtenidos
  List<Plato> listaPlatos = platos(result);

  // Imprime la lista de platos
  listaPlatos.forEach((plato) {
    print(
        'ID: ${plato.idPro}, Nombre: ${plato.nomPro}, Precio: ${plato.preUni}, URL Imagen: ${plato.urlImg}, ID Categoría: ${plato.idCatPer}');
  });
  // Cierra la conexión cuando hayas terminado de usarla
  await conn.close();
}
