import 'package:postgres/postgres.dart';

class DatabaseConnection {
  static Future<Connection> openConnection() async {
    final conn = await Connection.open(Endpoint(
      host: 'localhost',
      port: 5432,
      database: 'Restaurantes',
      username: 'postgres',
      password: 'admin',
    ), settings: ConnectionSettings(sslMode: SslMode.disable));

    print('Connection established!');
    return conn;
  }
}