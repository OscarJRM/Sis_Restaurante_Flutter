// ignore_for_file: file_names

import 'package:flutter/material.dart';

class IngresosPage extends StatefulWidget {
  const IngresosPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IngresosPage createState() => _IngresosPage();
}

class _IngresosPage extends State<IngresosPage> {
  String? selectedMes;
  String? selectedYear;
  List<String> dropdownItems = ['Opción 1', 'Opción 2', 'Opción 3', 'Opción 4'];
  List<String> mesesItems = [
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
  List<String> yearItems = ['2023', '2024'];

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.4;
    return Container(
        height: 200,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'INGRESOS',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 4.0,
              width: maxWidth,
              color: const Color.fromARGB(
                  255, 69, 4, 97), // Cambia a tu color preferido
            ),
            const SizedBox(height: 6),
            Center(
              child: Row(
                children: [
                  const Text(
                      '                                                                                                                                             '),
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
                  const Text('               '),
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
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedMes != null && selectedYear != null
                  ? _verReporte
                  : null,
              child: const Text('Ver Reporte'),
            ),
          ],
        ));
  }

  void _verReporte() {}
}
