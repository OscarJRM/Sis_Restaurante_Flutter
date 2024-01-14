import 'package:flutter/material.dart';

class IngresosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Ingresos y Egresos (Dinero efectivo)',
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: 20),
        DropdownButton<String>(
          value: 'Ingresos',
          items: [
            DropdownMenuItem(
              child: Text('Ingresos'),
              value: 'Ingresos',
            ),
            DropdownMenuItem(
              child: Text('Egresos'),
              value: 'Egresos',
            ),
          ],
          onChanged: (value) {},
        ),
        SizedBox(height: 20),
        Text(
          '2017',
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          child: Text('Ver Gráfico'),
        ),
        SizedBox(height: 20),
        DropdownButton<String>(
          value: 'Ingresos',
          items: [
            DropdownMenuItem(
              child: Text('Ingresos'),
              value: 'Ingresos',
            ),
            DropdownMenuItem(
              child: Text('Egresos'),
              value: 'Egresos',
            ),
          ],
          onChanged: (value) {},
        ),
        SizedBox(height: 20),
        Text(
          '2017',
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          child: Text('Ver Gráfico'),
        ),
      ],
    );
  }
}
