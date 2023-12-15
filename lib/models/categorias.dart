import 'package:postgres/postgres.dart';
import '../BaseDatos/conexion.dart';

class Categoria {
  String idCat;
  String nomCat;
  String desCat;

  Categoria({
    required this.idCat,
    required this.nomCat,
    required this.desCat,
  });

}
 List<Categoria> cargarCategorias(Result result) {
    return result.map((row) {
      return Categoria(
        idCat: row[0] as String,
        nomCat: row[1] as String,
        desCat: row[2] as String,
      );
    }).toList();
  }

void main() async {
  final conn = await DatabaseConnection.openConnection();

  // Utiliza query en lugar de execute para obtener un resultado
  // Utiliza query en lugar de prepare y run para obtener un resultado
  final result = await conn.execute("SELECT * from CATEGORIAS");

  // Llena la lista de mesas con los resultados obtenidos
  List<Categoria> listaCategorias = cargarCategorias(result);

  // Imprime la lista de mesas
  listaCategorias.forEach((categoria) {
    print(
        'ID: ${categoria.idCat}, Nombre: ${categoria.nomCat}, Descripción: ${categoria.desCat}');
  });

  // Cierra la conexión cuando hayas terminado de usarla
  await conn.close();
}
