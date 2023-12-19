import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

class ConexionDB {
  // ignore: prefer_typing_uninitialized_variables
  late Connection _conn;
  Future<Connection?> connect() async {
    try {
      return _conn = await Connection.open(
        Endpoint(
          host: 'restaurante-metodologias-agiles.postgres.database.azure.com',
          port: 5432,
          database: 'proyecto_restaurante',
          username: 'AdminRestaurante',
          password: 'Postgres123',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.require),
      );
    } on Exception {
      if (kDebugMode) {
        print(Exception);
        return null;
      }
    }
    return null;
  }

  Future<void> close() async {
    await _conn.close();
  }
}
