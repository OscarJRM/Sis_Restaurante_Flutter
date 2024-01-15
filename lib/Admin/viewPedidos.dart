// ignore_for_file: file_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sistema_restaurante/BaseDatos/conexion.dart';
import 'package:sistema_restaurante/models/categorias.dart';

class ProductoData {
  final String nombre;
  final int cantidad;

  ProductoData({required this.nombre, required this.cantidad});
}

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PedidosPage createState() => _PedidosPage();
}

class _PedidosPage extends State<PedidosPage> {
  String? selectedCategoria;
  String? selectedMes;
  String? selectedYear;
  List<String> categoriasItems = [];
  final List<String> mesesItems = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  final List<String> yearItems = ['2023', '2024'];

  @override
  void initState() {
    super.initState();
    cargarCategorias().then((categorias) {
      setState(() {
        categoriasItems = categorias;
      });
    });
  }

  Future<void> _showBarChartDialog(BuildContext context,
      Future<List<BarChartGroupData>> Function() getData) async {
    final List<BarChartGroupData> barChartData = await getData();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Gráfico de Barras'),
                SizedBox(height: 16.0),
                Container(
                  width: 300.0,
                  height: 300.0,
                  child: BarChart(
                    BarChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: SideTitles(showTitles: true),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) => value.toString(),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      barGroups: barChartData,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.4;
    return Center(
        child: Container(
            height: 500,
            constraints: BoxConstraints(maxWidth: maxWidth),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 69, 4, 97),
                width: 4.0,
              ),
              top: BorderSide(
                color: Color.fromARGB(255, 69, 4, 97),
                width: 4.0,
              ),
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'PEDIDOS',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                ),
                const SizedBox(height: 25),
                Container(
                  height: 4.0,
                  width: maxWidth,
                  color: const Color.fromARGB(
                      255, 69, 4, 97), // Cambia a tu color preferido
                ),
                const SizedBox(height: 20),
                Text(
                  'Platos Vendidos',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 30),
                DropdownButton<String>(
                  value: selectedCategoria,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategoria = newValue!;
                    });
                  },
                  items: categoriasItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text('Seleccione una categoría'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('                           '),
                    DropdownButton<String>(
                      value: selectedMes,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMes = newValue!;
                        });
                      },
                      items: mesesItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text('Seleccione un Mes'),
                    ),
                    const Text('                  '),
                    DropdownButton<String>(
                      value: selectedYear,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedYear = newValue!;
                        });
                      },
                      items: yearItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text('Seleccione un Año'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: selectedCategoria != null &&
                          selectedMes != null &&
                          selectedYear != null
                      ? () async {
                          await _showBarChartDialog(
                              context,
                              cargarProductos as Future<List<BarChartGroupData>>
                                  Function());
                        }
                      : null,
                  child: const Text('Ver Reporte'),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 4.0,
                  width: maxWidth,
                  color: const Color.fromARGB(
                      255, 69, 4, 97), // Cambia a tu color preferido
                ),
                const SizedBox(height: 13),
                Text(
                  'Horarios de Pedidos',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: null,
                  child: const Text('Ver Reporte'),
                ),
              ],
            )));
  }

  Future<List<String>> cargarCategorias() async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute('SELECT * from categorias');

    final List<String> productosList = results
        .map((row) {
          return row[1].toString(); // Agrega el 'return' aquí
        })
        .cast<String>()
        .toList();

    await connection.close();

    return productosList;
  }

  Future<List<ProductoData>> cargarProducto() async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        "SELECT TO_CHAR(fec_hor_ped, 'YYYY-MM-DD') AS fecha,COUNT(*) FROM maestro_pedidos WHERE fec_hor_ped BETWEEN '$selectedDateInicio' AND '$selectedDateFin' GROUP BY fecha Order by (fecha);");
    final List<ProductoData> data = results.map((row) {
      return ProductoData(
        nombre: row[0].toString(),
        cantidad: int.parse(row[1].toString()),
      );
    }).toList();

    await connection.close();
    return data;
  }

  Future<List<FlSpot>> cargarProductos() async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        "SELECT TO_CHAR(fec_hor_ped, 'YYYY-MM-DD') AS fecha,COUNT(*) FROM maestro_pedidos WHERE fec_hor_ped BETWEEN '$selectedDateInicio' AND '$selectedDateFin' GROUP BY fecha Order by (fecha);");
    final List<ProductoData> data = results.map((row) {
      return ProductoData(
        nombre: row[0].toString(),
        cantidad: int.parse(row[1].toString()),
      );
    }).toList();

    await connection.close();

    List<FlSpot> lineChartData = data.asMap().entries.map((entry) {
      final index = entry.key;
      final productoData = entry.value;

      return FlSpot(index.toDouble(), productoData.cantidad.toDouble());
    }).toList();

    return lineChartData;
  }
}
