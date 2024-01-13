import 'package:postgres/postgres.dart';

class DatabaseConnection {
  static Future<Connection> openConnection() async {
    final conn = await Connection.open(
        Endpoint(
          host: 'restaurante-metodologias-agiles.postgres.database.azure.com',
          port: 5432,
          database: 'proyecto_restaurante',
          username: 'AdminRestaurante',
          password: 'Postgres123',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.require));

    print('Connection established!');
    return conn;
  }
}
