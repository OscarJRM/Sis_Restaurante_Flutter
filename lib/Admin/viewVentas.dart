// ignore_for_file: file_names

import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistema_restaurante/BaseDatos/conexion.dart';

class ProductoData {
  final String nombre;
  final int cantidad;

  ProductoData({required this.nombre, required this.cantidad});
}

class VentasPage extends StatefulWidget {
  const VentasPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VentasPageState createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  DateTime selectedDateInicio = DateTime.now();
  DateTime selectedDateFin = DateTime.now();

  Future<void> _selectDate(BuildContext context, String tipo) async {
    if (tipo == 'inicio') {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateInicio,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (picked != null && picked != selectedDateInicio) {
        setState(() {
          selectedDateInicio = picked;
        });
      }
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateFin,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (picked != null && picked != selectedDateFin) {
        setState(() {
          selectedDateFin = picked;
        });
      }
    }
  }

  Future<void> _showLineChartDialog(
      BuildContext context, Future<List<FlSpot>> Function() getData) async {
    final List<FlSpot> lineChartData = await getData();
    final List<ProductoData> fechasVenta = await cargarProductos();

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Reporte de Ventas'),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: 800,
                  height: 400,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      minY: 0,
                      titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                            axisNameSize: 20,
                            axisNameWidget: Text('Pedidos Vendidos'),
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 50,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            axisNameSize: 20,
                            axisNameWidget: Text('Fecha de Venta'),
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 30,
                            ),
                          )),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: lineChartData,
                          isCurved: false,
                          color: Colors.blue,
                          dotData: const FlDotData(
                            show: true,
                          ),
                          belowBarData: BarAreaData(show: true),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.blueAccent,
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              // Configuración del contenido del tooltip
                              return LineTooltipItem(
                                'Cantidad: ${int.parse(touchedSpot.y.toStringAsFixed(0))} \nFecha: ${fechasVenta[int.parse(touchedSpot.x.toStringAsFixed(0))].nombre}', // Valor del eje Y
                                const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<ProductoData>> cargarProductos() async {
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

  Future<List<FlSpot>> cargarProductosDia() async {
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

  @override
  Widget build(BuildContext context) {
    String dateInicio = DateFormat('dd/MM/yyyy').format(selectedDateInicio);
    String dateFin = DateFormat('dd/MM/yyyy').format(selectedDateFin);

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
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'VENTAS',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
            ),
            const SizedBox(height: 25),
            Container(
              height: 4.0,
              width: maxWidth,
              color: const Color.fromARGB(255, 69, 4, 97),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 50),
            Row(
              children: [
                const Text(
                  'Fecha Inicial:  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  dateInicio,
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  onPressed: () => _selectDate(context, 'inicio'),
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Text(
                  'Fecha Final:    ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  dateFin,
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  onPressed: () => _selectDate(context, 'fin'),
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: (selectedDateInicio.isBefore(selectedDateFin) &&
                      !selectedDateInicio.isAtSameMomentAs(selectedDateFin))
                  ? () async {
                      await _showLineChartDialog(context, cargarProductosDia);
                    }
                  : null,
              child: const Text('Ver Reporte'),
            ),
          ],
        ),
      ),
    );
  }
}
