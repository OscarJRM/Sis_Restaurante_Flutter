import 'package:flutter/material.dart';
import '../BaseDatos/conexion.dart';

class Mesa {
  String numero;
  String estado;

  Mesa({
    required this.numero,
    required this.estado,
  });
}

class MesaWidget extends StatelessWidget {
  final Mesa mesa;

  MesaWidget({required this.mesa});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        title: Text('Mesa #${mesa.numero}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estado: ${mesa.estado}'),
          ],
        ),
        // Puedes agregar botones o acciones aquí según sea necesario
      ),
    );
  }
}

class ListaMesas extends StatefulWidget {
  @override
  _ListaMesasState createState() => _ListaMesasState();
}

class _ListaMesasState extends State<ListaMesas> {
  List<Mesa> mesas = [];

  @override
  void initState() {
    super.initState();
    cargarMesas();
  }

  Future<void> cargarMesas() async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute('SELECT * FROM MESAS');

    final List<Mesa> mesasList = results.map((row) {
      return Mesa(
        numero: row[0].toString(),
        estado: row[1].toString(),
      );
    }).toList();

    setState(() {
      mesas = mesasList;
    });

    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mesas.length,
      itemBuilder: (context, index) {
        return MesaWidget(mesa: mesas[index]);
      },
    );
  }
}
