// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../BaseDatos/conexion.dart';

class PagoEfectivoView extends StatefulWidget {
  @override
  _PagoEfectivoViewState createState() => _PagoEfectivoViewState();
}

class _PagoEfectivoViewState extends State<PagoEfectivoView> {
  TextEditingController cedulaController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController correoController = TextEditingController();

  bool clienteExistente = false;

  // Datos para la factura
  double montoTotal = 10.0;
  String fechaEmision = DateTime.now().toLocal().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago en Efectivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cedulaController,
              decoration: const InputDecoration(
                labelText: 'Cédula del Cliente',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await verificarCliente();
                setState(() {});

                if (clienteExistente) {
                  _mostrarInfoCliente();
                } else {
                  _mostrarFormularioRegistroCliente();
                }
              },
              child: const Text('Buscar Cliente'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verificarCliente() async {
    final connection = await DatabaseConnection.instance.openConnection();

    final results = await connection.execute(
      "SELECT * FROM clientes WHERE ced_cli = '${cedulaController.text}'",
    );

    setState(() {
      clienteExistente = results.isNotEmpty;
    });

    await connection.close();
  }

void _mostrarInfoCliente() async {
  final connection = await DatabaseConnection.instance.openConnection();

  final results = await connection.execute(
    "SELECT * FROM clientes WHERE ced_cli = '${cedulaController.text}'",
  );

  await connection.close();

  if (results.isNotEmpty) {
    final clienteInfo = results.first;

final columnNames = ['Cedula', 'Nombre', 'Apellido', 'Direccion', 'Telefono', 'Correo'];

showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Información del Cliente'),
      content: Column(
        children: [
          ...clienteInfo.asMap().entries.map(
            (entry) => ListTile(
              title: Text('${columnNames[entry.key]}: ${entry.value}'),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
        ElevatedButton(
          onPressed: () async {
            await facturarCliente();

            Navigator.of(context).pop();
          },
          child: const Text('Facturar'),
        ),
      ],
    );
  },
);

  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cliente no encontrado'),
          content: const Text('No se encontró ningún cliente con la cédula proporcionada.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}




  void _mostrarFormularioRegistroCliente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrar Nuevo Cliente'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del Cliente'),
                ),
                TextField(
                  controller: apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido del Cliente'),
                ),
                TextField(
                  controller: direccionController,
                  decoration: const InputDecoration(labelText: 'Dirección del Cliente'),
                ),
                TextField(
                  controller: telefonoController,
                  decoration: const InputDecoration(labelText: 'Teléfono del Cliente'),
                ),
                TextField(
                  controller: correoController,
                  decoration: const InputDecoration(labelText: 'Correo del Cliente'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await registrarNuevoCliente();
                Navigator.of(context).pop();
                setState(() {
                  clienteExistente = true;
                });
              },
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );
  }

Future<void> facturarCliente() async {
  final connection = await DatabaseConnection.instance.openConnection();

  await connection.execute(
    "INSERT INTO facturas (ced_cli, id_pag, monto_total, fecha_emision) VALUES "
"('${cedulaController.text}', 1, $montoTotal, '${DateTime.now().toLocal()}')",
  );

  await connection.close();

  print('Cliente facturado con éxito');
}

Future<void> registrarNuevoCliente() async {
  final connection = await DatabaseConnection.instance.openConnection();

  await connection.execute(
    "INSERT INTO clientes (ced_cli, nom_cli, ape_cli, dir_cli, tel_cli, cor_cli) VALUES "
    "('${cedulaController.text}', '${nombreController.text}', '${apellidoController.text}', "
    "'${direccionController.text}', '${telefonoController.text}', '${correoController.text}')",
  );

  await connection.close();
}

}

void main() {
  runApp(MaterialApp(
    home: PagoEfectivoView(),
  ));
}
