import 'package:flutter/material.dart';

class VentasPage extends StatefulWidget {
  @override
  _VentasPage createState() => _VentasPage();
}

class _VentasPage extends State<VentasPage> {
  int selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    double maxWidth =
        MediaQuery.of(context).size.width * 0.4; // ajusta según sea necesario

    return Center(
        child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Ventas',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<int>(
                        title: Text('Diarias'),
                        value: 1,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<int>(
                        title: Text('Mensuales'),
                        value: 2,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Fecha Inicial',
                  ),
                ),
                const SizedBox(height: 10),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Fecha Final',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Ver Gráfico'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Productos Más vendidos (Top 10)',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('For forma ce Pago'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Ver Gráfico'),
                ),
              ],
            )));
  }
}
