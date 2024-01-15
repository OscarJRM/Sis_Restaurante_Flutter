// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../BaseDatos/conexion.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

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

  double montoTotal = 10000.0;
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

      final columnNames = [
        'Cedula',
        'Nombre',
        'Apellido',
        'Direccion',
        'Telefono',
        'Correo'
      ];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Información del Cliente'),
            content: Column(
              children: [
                ...clienteInfo.asMap().entries.map(
                      (entry) => ListTile(
                        title:
                            Text('${columnNames[entry.key]}: ${entry.value}'),
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
            content: const Text(
                'No se encontró ningún cliente con la cédula proporcionada.'),
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
                  decoration:
                      const InputDecoration(labelText: 'Nombre del Cliente'),
                ),
                TextField(
                  controller: apellidoController,
                  decoration:
                      const InputDecoration(labelText: 'Apellido del Cliente'),
                ),
                TextField(
                  controller: direccionController,
                  decoration:
                      const InputDecoration(labelText: 'Dirección del Cliente'),
                ),
                TextField(
                  controller: telefonoController,
                  decoration:
                      const InputDecoration(labelText: 'Teléfono del Cliente'),
                ),
                TextField(
                  controller: correoController,
                  decoration:
                      const InputDecoration(labelText: 'Correo del Cliente'),
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
    final globalState = Provider.of<GlobalState>(context, listen: false);

      await connection.execute(
    "UPDATE maestro_pedidos SET id_est_ped = 'DES' WHERE id_ped = ${globalState.idPed}",
  );

  // Obtener el número de mesa del pedido
  final resultsMesa = await connection.execute(
    "SELECT num_mes_pid FROM maestro_pedidos WHERE id_ped = ${globalState.idPed}",
  );

  if (resultsMesa.isNotEmpty) {
    final numMesa = resultsMesa.first[0];

    await connection.execute(
      "UPDATE mesas SET est_mes = 'DISPONIBLE' WHERE num_mes = $numMesa",
    );
  }

    final results = await connection.execute(
      "SELECT * FROM clientes WHERE ced_cli = '${cedulaController.text}'",
    );

    if (results.isNotEmpty) {
      final clienteInfo = results.first;

      final columnNames = [
        'Cedula',
        'Nombre',
        'Apellido',
        'Direccion',
        'Telefono',
        'Correo'
      ];

      final resultsPlatos = await connection.execute(
        "SELECT productos.nom_pro, detalle_pedidos.can_pro_ped, productos.pre_uni_pro FROM detalle_pedidos "
        "INNER JOIN productos ON detalle_pedidos.id_pro_ped = productos.id_pro "
        "WHERE detalle_pedidos.id_ped_per = ${globalState.idPed}",
      );

      final detallesPlatos = resultsPlatos.map((detalle) {
        return [
          detalle[0],
          detalle[1],
          detalle[2],
          // Agrega otras columnas según sea necesario
        ];
      }).toList();

      // Crear el PDF
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Factura',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 18)),
              pw.SizedBox(height: 12),
              ...clienteInfo.asMap().entries.map(
                    (entry) =>
                        pw.Text('${columnNames[entry.key]}: ${entry.value}'),
                  ),
              pw.SizedBox(height: 12),
              pw.Text('Monto Total: \$${globalState.Total}'),
              pw.Text(
                  'Fecha de Emisión: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}'),
              pw.SizedBox(height: 12),
              pw.Text('Detalles de los Platos:'),
              pw.SizedBox(height: 6),
              // Bucle para agregar detalles de los platos
              for (var detallePlato in detallesPlatos)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${detallePlato[0]}'),
                    pw.Text('Cantidad: ${detallePlato[1]}'),
                    pw.Text(
                        'Total: \$${(double.parse(detallePlato[1].toString()) * double.parse(detallePlato[2].toString())).toStringAsFixed(2)}'),
                  ],
                ),
            ],
          ),
        ),
      );

      // Guardar el PDF en el sistema de archivos
      final pdfOutput = await getApplicationDocumentsDirectory();
      final pdfFileName =
          'factura_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final pdfFile = File('${pdfOutput.path}/$pdfFileName');
      await pdfFile.writeAsBytes(await pdf.save());

      // Actualizar la base de datos con la ruta del PDF
      final pdfPath = pdfFile.path;
      await connection.execute(
        "INSERT INTO facturas (ced_cli, id_pag, monto_total, fecha_emision, pdf_path, id_ped_per) VALUES "
        "('${cedulaController.text}', 1, ${globalState.Total}, '${DateTime.now().toLocal()}', '$pdfPath', ${globalState.idPed})",
      );

      await connection.close();

      print('Cliente facturado con éxito. PDF almacenado en: $pdfPath');
      _mostrarPDF(pdfPath);
    } else {
      // Manejar el caso en que no se encuentre el cliente
    }
  }

  void _mostrarPDF(String pdfPath) {
    OpenFile.open(pdfPath);
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
