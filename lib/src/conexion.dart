import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

class ConexionDB {
  late Connection _conn;

  Future<Connection?> connect() async {
    try {
      _conn = await Connection.open(
        Endpoint(
          host: 'restaurante-metodologias-agiles.postgres.database.azure.com',
          port: 5432,
          database: 'proyecto_restaurante',
          username: 'AdminRestaurante',
          password: 'Postgres123',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.require),
      );
      return _conn;
    } catch (e) {
      if (kDebugMode) {
        print('Error al conectar: $e');
      }
      return null;
    }
  }

  Future<void> close() async {
    await _conn.close();
  }
}
