import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'productoCustom.dart';
import '../models/platos.dart';
import '../BaseDatos/conexion.dart';

class ProductosMesero extends StatefulWidget {
  const ProductosMesero({Key? key}) : super(key: key);

  @override
  _ProductosMeseroState createState() => _ProductosMeseroState();
}

class _ProductosMeseroState extends State<ProductosMesero> {
  late List<Plato> listaPlatos = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final conn = await DatabaseConnection.openConnection();
    final result = await conn.execute("SELECT * from Productos");
    setState(() {
      listaPlatos = Platos(result);
    });
    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: listaPlatos != null
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 255,
                crossAxisCount: 2,
                mainAxisSpacing: 23,
                crossAxisSpacing: 24,
              ),
              itemCount: listaPlatos.length,
              itemBuilder: (context, index) {
                return productoCustom(plato: listaPlatos[index]);
              },
            )
          : CircularProgressIndicator(), // Puedes mostrar un indicador de carga mientras se obtienen los datos
    );
  }
}

/*
class productosMesero extends StatelessWidget {
  const productosMesero({super.key});

  @override
  Future<Widget> build(BuildContext context) async {
    final conn = await DatabaseConnection.openConnection();

  // Utiliza query en lugar de execute para obtener un resultado
  // Utiliza query en lugar de prepare y run para obtener un resultado
  final result = await conn.execute("SELECT * from Productos");

  // Llena la lista de platos con los resultados obtenidos
  List<Plato> listaPlatos = Platos(result);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 200,
              crossAxisCount: 2,
              mainAxisSpacing: 23,
              crossAxisSpacing: 24),
          itemCount: listaPlatos.length,
          itemBuilder: (context, index) {
            return productoCustom(plato: listaPlatos[index]);
          }),
    );
  }
}
*/
