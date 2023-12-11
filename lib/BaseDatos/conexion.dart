import 'package:postgres/postgres.dart';

class DatabaseConnection {
  static Future<Connection> openConnection() async {
    final conn = await Connection.open(
        Endpoint(
          host: 'roundhouse.proxy.rlwy.net',
          port: 49265,
          database: 'railway',
          username: 'postgres',
          password: 'CGbDFF*ABcg14D632A2c666cdBBB25*e',
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable));

    print('Connection established!');
    return conn;
  }
}

void main() async {
  final conn = await DatabaseConnection.openConnection();

  // Utiliza query en lugar de execute para obtener un resultado
  // Utiliza query en lugar de prepare y run para obtener un resultado

  await conn.close();
}
