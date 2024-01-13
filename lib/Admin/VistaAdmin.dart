import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Responsive App'),
          ),
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.desktop
              ? null // No mostrar el menú lateral en pantallas de escritorio
              : Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Text(
                          'Menú',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('Ventas Realizadas'),
                        onTap: () {
                          Navigator.pop(context);
                          // Lógica para manejar la selección de la opción 1
                        },
                      ),
                      ListTile(
                        title: Text('Productos '),
                        onTap: () {
                          Navigator.pop(context);
                          // Lógica para manejar la selección de la opción 2
                        },
                      ),
                    ],
                  ),
                ),
          body: Center(
            child: Text(
              'Contenido principal',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}
