import 'package:flutter/material.dart';

class PedidosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Compras',
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Text('Diarias'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Mensuales'),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            labelText: 'Fecha Inicial',
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Fecha Final',
          ),
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
