import "package:flutter/material.dart";
import 'package:sistema_restaurante/pages/mesasCustom.dart';
import '../BaseDatos/conexion.dart';
import '../models/mesas.dart';
import 'mesasCustom.dart';

class Mesas extends StatefulWidget {
  const Mesas({Key? key}) : super(key: key);

  @override
  State<Mesas> createState() => _MesasState();
}

class _MesasState extends State<Mesas> {
  late List<Mesa> listaMesas = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final conn = await DatabaseConnection.openConnection();
    final result = await conn.execute("SELECT * FROM MESAS");
    setState(() {
      listaMesas = cargarMesas(result);
    });
    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: listaMesas != null
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 65,
                crossAxisCount: 1,
                mainAxisSpacing: 23,
                crossAxisSpacing: 24,
              ),
              itemCount: listaMesas.length,
              itemBuilder: (context, index) {
                return mesasCustom(mesa: listaMesas[index]);
              },
            )
          : const CircularProgressIndicator(), // Puedes mostrar un indicador de carga mientras se obtienen los datos
    );
  }
}
