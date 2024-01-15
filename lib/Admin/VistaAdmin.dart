import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sistema_restaurante/Admin/ContentNavigator.dart';
import 'package:sistema_restaurante/Admin/listaVentas.dart';
import 'package:sistema_restaurante/Admin/reportes.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:sistema_restaurante/src/login.dart';

//Paquete: flutter pub add fl_chart

// ignore: camel_case_types
class vistaAdmin extends StatefulWidget {
  final String _name;
  final String _apellido;
  const vistaAdmin(this._name, this._apellido, {super.key});
  @override
  State<vistaAdmin> createState() => _menuAdmin();
}

// ignore: camel_case_types
class _menuAdmin extends State<vistaAdmin> {
  late ContentNavigator contentNavigator;

  @override
  void initState() {
    super.initState();
    contentNavigator = ContentNavigator();
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    globalState.updateNom(widget._name);
    globalState.updateApe(widget._apellido);

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
            title: const Text(
              'GERENCIA',
            ),
            backgroundColor: const Color.fromARGB(255, 26, 27, 29),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.desktop
              ? Drawer(
                  backgroundColor: const Color.fromARGB(255, 26, 27, 29),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                                radius:
                                    40, // Ajusta el tamaño del círculo según tus preferencias
                                backgroundImage: AssetImage(
                                    'images/icono-del-administrador-de-administración-equipos-personas-274290093.webp')),
                            const SizedBox(
                                height:
                                    10), // Espacio entre la imagen y el texto
                            Text(
                              "Usuario: ${widget._name} ${widget._apellido}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: const Text('Registro de Ventas'),
                        textColor: Colors.white,
                        onTap: () {
                          contentNavigator.navigateTo('/registro_ventas');
                          // Lógica para manejar la selección de la opción 1
                        },
                      ),
                      ListTile(
                        title: const Text('Reportes'),
                        textColor: Colors.white,
                        onTap: () {
                          contentNavigator.navigateTo('/reportes');
                          // Lógica para manejar la selección de la opción 2
                        },
                      ),
                      ListTile(
                        title: const Text('Cerrar Sesión'),
                        textColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                          // Lógica para manejar la selección de la opción 2
                        },
                      ),
                    ],
                  ),
                )
              : null,
          body: Navigator(
            key: contentNavigator.navigatorKey,
            onGenerateRoute: (settings) {
              Widget page;
              switch (settings.name) {
                case '/registro_ventas':
                  page = const VentasScreen();
                  break;
                case '/reportes':
                  page = const ReportesScreen();
                  break;
                default:
                  page =
                      const SizedBox(); // Puedes cambiar esto a una pantalla por defecto
              }
              return MaterialPageRoute(builder: (context) => page);
            },
          ),
        );
      },
    );
  }
}
