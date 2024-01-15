import 'package:flutter/material.dart';
import 'package:sistema_restaurante/BaseDatos/conexion.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VentasScreen createState() => _VentasScreen();
}

class _VentasScreen extends State<VentasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Column(
          children: [
            const Text('PEDIDOS DESPACHADOS'),
            DataTable(columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Descripción')),
              DataColumn(label: Text('Completado')),
            ], rows: const [
              DataRow(cells: [
                DataCell(Text('1')),
                DataCell(Text('Juan')),
                DataCell(Text('25')),
              ]),
              DataRow(cells: [
                DataCell(Text('2')),
                DataCell(Text('María')),
                DataCell(Text('30')),
              ]),
              DataRow(cells: [
                DataCell(Text('3')),
                DataCell(Text('Carlos')),
                DataCell(Text('22')),
              ]),
            ])
          ],
        )));
  }
}

class ProductoData {
  final String nombre;
  final int cantidad;

  ProductoData({required this.nombre, required this.cantidad});
}

Future<List<ProductoData>> cargarProductosMes(int pedidoId) async {
  final connection = await DatabaseConnection.instance.openConnection();
  final results = await connection.execute(
      "select DATE_TRUNC('month', fec_hor_ped) AS mes, count(*) from maestro_pedidos where fec_hor_ped BETWEEN '2023-11-01' AND '2024-01-31' group by mes;");
  final List<ProductoData> productosList = results.map((row) {
    return ProductoData(
        nombre: row[2].toString(), cantidad: int.parse(row[1].toString()));
  }).toList();

  await connection.close();

  return productosList;
}

Future<List<ProductoData>> cargarProductosDia(int pedidoId) async {
  final connection = await DatabaseConnection.instance.openConnection();
  final results = await connection.execute(
      "select DATE_TRUNC('day', fec_hor_ped) AS dia, count(*) from maestro_pedidos where fec_hor_ped BETWEEN '2024-01-01' AND '2024-01-31' group by dia");
  final List<ProductoData> productosList = results.map((row) {
    return ProductoData(
        nombre: row[2].toString(), cantidad: int.parse(row[1].toString()));
  }).toList();

  await connection.close();

  return productosList;
}
