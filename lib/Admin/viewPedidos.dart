// ignore_for_file: file_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sistema_restaurante/BaseDatos/conexion.dart';

class ProductoData {
  final String nombre;
  final int cantidad;

  ProductoData({required this.nombre, required this.cantidad});
}

class Horario {
  final String hora;
  final int cantidad;

  Horario({required this.hora, required this.cantidad});
}

class PedidosPage extends StatefulWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  String? selectedCategoria;
  String? selectedMes;
  String? selectedYear;
  int? selectedNMes;
  List<ProductoData> platos = [];
  List<Horario> horas = [];
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
    platos = await cargarProducto();
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Platos Pedidos',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                SizedBox(
                  width: 800.0,
                  height: 450.0,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.blueAccent,
                        tooltipRoundedRadius: 8,
                        getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                        ) {
                          return BarTooltipItem(
                              'Cantidad: ${rod.toY.toStringAsFixed(0)}',
                              const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold));
                        },
                      )),
                      gridData: const FlGridData(show: false),
                      alignment: BarChartAlignment.spaceAround,
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          axisNameSize: 20,
                          axisNameWidget: Text(
                              'Productos de la Categoría: ${selectedCategoria!}'),
                          sideTitles: const SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                            axisNameSize: 20,
                            axisNameWidget:
                                Text('Veces Pedido en: ${selectedMes!}'),
                            sideTitles: const SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              interval: 1,
                            )),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 100,
                          getTitlesWidget: getTitles,
                        )),
                      ),
                      borderData: FlBorderData(show: true),
                      barGroups: barChartData,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
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

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = platos[int.parse(value.toStringAsFixed(0))].nombre;
    return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 4,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(text, style: style),
        ));
  }

  Widget getTitlesHora(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = horas[int.parse(value.toStringAsFixed(0))].hora;
    return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 4,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(text, style: style),
        ));
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
          ),
        ),
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
              color: const Color.fromARGB(255, 69, 4, 97),
            ),
            const SizedBox(height: 20),
            Text(
              'Platos Vendidos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            DropdownButton<String>(
              value: selectedCategoria,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategoria = newValue!;
                });
              },
              items:
                  categoriasItems.map<DropdownMenuItem<String>>((String value) {
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
                      selectedNMes = mesesItems.indexOf(selectedMes!) + 1;
                    });
                  },
                  items:
                      mesesItems.map<DropdownMenuItem<String>>((String value) {
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
                  items:
                      yearItems.map<DropdownMenuItem<String>>((String value) {
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
                      await _showBarChartDialog(context, cargarProductos);
                    }
                  : null,
              child: const Text('Ver Reporte'),
            ),
            const SizedBox(height: 16),
            Container(
              height: 4.0,
              width: maxWidth,
              color: const Color.fromARGB(255, 69, 4, 97),
            ),
            const SizedBox(height: 13),
            Text(
              'Horarios de Pedidos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _showBarHorarioDialog(context, cargarHorarios);
              },
              child: const Text('Ver Reporte'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBarHorarioDialog(BuildContext context,
      Future<List<BarChartGroupData>> Function() getData) async {
    final List<BarChartGroupData> barChartData = await getData();
    horas = await horarios();
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('HORARIOS DE PEDIDOS',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                SizedBox(
                  width: 800.0,
                  height: 450.0,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.blueAccent,
                        tooltipRoundedRadius: 8,
                        getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                        ) {
                          return BarTooltipItem(
                              'Pedidos: ${rod.toY.toStringAsFixed(0)}',
                              const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold));
                        },
                      )),
                      gridData: const FlGridData(show: false),
                      alignment: BarChartAlignment.spaceAround,
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          axisNameSize: 20,
                          axisNameWidget: Text('Hora (hh:mm)'),
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                            axisNameSize: 20,
                            axisNameWidget: Text('Número de Pedidos'),
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              interval: 1,
                            )),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 100,
                          getTitlesWidget: getTitlesHora,
                        )),
                      ),
                      borderData: FlBorderData(show: true),
                      barGroups: barChartData,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
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
        "select count(*) as cantidad, p.nom_pro from detalle_pedidos as d inner join maestro_pedidos as m on d.id_ped_per = m.id_ped inner join productos as p on d.id_pro_ped = p.id_pro  inner join categorias as c on p.id_cat_per = c.id_cat and c.nom_cat='$selectedCategoria' WHERE extract (MONTH from m.fec_hor_ped) = $selectedNMes and extract(YEAr from m.fec_hor_ped) = $selectedYear group by (nom_pro);");
    final List<ProductoData> data = results.map((row) {
      return ProductoData(
        nombre: row[1].toString(),
        cantidad: int.parse(row[0].toString()),
      );
    }).toList();

    await connection.close();
    return data;
  }

  Future<List<BarChartGroupData>> cargarProductos() async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        "select count(*) as cantidad, p.nom_pro from detalle_pedidos as d inner join maestro_pedidos as m on d.id_ped_per = m.id_ped inner join productos as p on d.id_pro_ped = p.id_pro  inner join categorias as c on p.id_cat_per = c.id_cat and c.nom_cat='$selectedCategoria' WHERE extract (MONTH from m.fec_hor_ped) = $selectedNMes and extract(YEAr from m.fec_hor_ped) = $selectedYear group by (nom_pro);");
    final List<ProductoData> data = results.map((row) {
      return ProductoData(
        nombre: row[1].toString(),
        cantidad: int.parse(row[0].toString()),
      );
    }).toList();

    await connection.close();

    List<BarChartGroupData> barChartData = data.map((productoData) {
      return BarChartGroupData(
        x: data.indexOf(productoData),
        barRods: [
          BarChartRodData(
            toY: productoData.cantidad.toDouble(),
            color: Colors.blue,
          ),
        ],
      );
    }).toList();

    return barChartData;
  }

  Future<List<Horario>> horarios() async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        "SELECT EXTRACT(HOUR FROM fec_hor_ped) AS hora, COUNT(*) FROM maestro_pedidos GROUP BY hora ORDER BY hora;");
    final List<Horario> data = results.map((row) {
      return Horario(
        hora: '${row[0]}:00 - ${row[0]}:59',
        cantidad: int.parse(row[1].toString()),
      );
    }).toList();
    await connection.close();
    return data;
  }

  Future<List<BarChartGroupData>> cargarHorarios() async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        "SELECT EXTRACT(HOUR FROM fec_hor_ped) AS hora, COUNT(*) FROM maestro_pedidos GROUP BY hora ORDER BY hora;");
    final List<Horario> data = results.map((row) {
      return Horario(
        hora: '${row[0]}:00 - ${row[0]}:59',
        cantidad: int.parse(row[1].toString()),
      );
    }).toList();

    await connection.close();

    List<BarChartGroupData> barChartData = data.map((productoData) {
      return BarChartGroupData(
        x: data.indexOf(productoData),
        barRods: [
          BarChartRodData(
            toY: productoData.cantidad.toDouble(),
            color: Colors.blue,
          ),
        ],
      );
    }).toList();

    return barChartData;
  }
}
