import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'productoCustom.dart';
import '../models/platos.dart';
import '../BaseDatos/conexion.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';

class ProductosMesero extends StatefulWidget {
  const ProductosMesero({Key? key}) : super(key: key);

  @override
  _ProductosMeseroState createState() => _ProductosMeseroState();
}

class _ProductosMeseroState extends State<ProductosMesero> {
  late List<Plato> listaPlatos = [];
  late List<Plato> listaFiltrada;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final conn = await DatabaseConnection.instance.openConnection();
    final result = await conn.execute("SELECT * from Productos");

    if (mounted) {
      setState(() {
        listaPlatos = Platos(result);
        listaFiltrada =
            listaPlatos; // Inicialmente, la lista filtrada es igual a la lista completa
      });
    }

    await conn.close();
  }

  void filtrarProductos(String query) {
    setState(() {
      listaFiltrada = listaPlatos
          .where((plato) =>
              plato.nomPro.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    globalState.pedidos.clear();
    globalState.pedidos.addAll(listaPlatos);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: listaPlatos != null
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 240,
                crossAxisCount: 2,
                mainAxisSpacing: 23,
                crossAxisSpacing: 24,
              ),
              itemCount: listaPlatos.length,
              itemBuilder: (context, index) {
                return productoCustom(plato: listaPlatos[index]);
              },
            )
          : const CircularProgressIndicator(), // Puedes mostrar un indicador de carga mientras se obtienen los datos
    );
  }
}
