import 'package:postgres/postgres.dart';

class DatabaseConnection {
  // Instancia única de la conexión
  static DatabaseConnection? _instance;

  // Constructor privado para evitar instancias directas
  DatabaseConnection._();

  // Método para obtener la única instancia (Singleton)
  static DatabaseConnection get instance {
    _instance ??= DatabaseConnection._(); // Crea la instancia si aún no existe
    return _instance!;
  }

  Future<Connection> openConnection() async {
    final conn = await Connection.open(
      Endpoint(
        host: 'restaurante-metodologias-agiles.postgres.database.azure.com',
        port: 5432,
        database: 'proyecto_restaurante',
        username: 'AdminRestaurante',
        password: 'Postgres123',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );

    print('Connection established!');
    return conn;
  }
}

void main() async {
  final conn = await DatabaseConnection.instance.openConnection();

  // Utiliza query en lugar de execute para obtener un resultado
  // Utiliza query en lugar de prepare y run para obtener un resultado

  await conn.close();
}
