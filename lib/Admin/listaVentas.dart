import 'package:flutter/material.dart';
import 'package:sistema_restaurante/BaseDatos/conexion.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VentasScreen createState() => _VentasScreen();
}

class Factura {
  final int id;
  final String fecha;
  final String cedcli;
  final String cliente;
  final String tipopago;
  final String empleado;
  final int pedido;
  final double total;

  Factura(
      {required this.id,
      required this.fecha,
      required this.cedcli,
      required this.cliente,
      required this.tipopago,
      required this.empleado,
      required this.pedido,
      required this.total});
}

class Producto {
  final String nombre;
  final int cantidad;

  Producto({required this.nombre, required this.cantidad});
}

class _VentasScreen extends State<VentasScreen> {
  List<Factura> listaFacturas = [];
  int pedido = 0;
  List<Producto> listaProductos = [];

  @override
  void initState() {
    super.initState();
    obtenerFacturas(); // Llamada a la función cargarFacturas al inicializar el estado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const Center(
                  child: Text('FACTURAS GENERADAS',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 30,
                ),
                DataTable(
                  dataRowMaxHeight: 80,
                  columns: const [
                    DataColumn(label: Text('N.')),
                    DataColumn(label: Text('FECHA F.')),
                    DataColumn(label: Text('CLIENTE F.')),
                    DataColumn(label: Text('DATOS. CLIENTE')),
                    DataColumn(label: Text('M. DE PAGO')),
                    DataColumn(label: Text('MESERO E.')),
                    DataColumn(label: Text('N. PEDIDO')),
                    DataColumn(label: Text('PRODUCTOS')),
                    DataColumn(label: Text('TOTAL')),
                  ],
                  rows: listaFacturas.map((factura) {
                    return DataRow(
                      cells: [
                        DataCell(Text(factura.id.toString())),
                        DataCell(Text(factura.fecha)),
                        DataCell(Text(factura.cedcli)),
                        DataCell(Text(factura.cliente)),
                        DataCell(Text(factura.tipopago)),
                        DataCell(Text(factura.empleado)),
                        DataCell(Text(factura.pedido.toString())),
                        DataCell(
                          FutureBuilder<List<Producto>>(
                            future: cargarProductos(factura.pedido),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: snapshot.data!.map((producto) {
                                      return Text(
                                          '${producto.nombre} x${producto.cantidad}');
                                    }).toList(),
                                  ),
                                );
                              } else {
                                return const Text('Sin productos');
                              }
                            },
                          ),
                        ),
                        DataCell(Text(factura.total.toString())),
                      ],
                    );
                  }).toList(),
                )
              ],
            )));
  }

  Future<void> obtenerFacturas() async {
    // Tu código existente para cargar las facturas
    listaFacturas = await cargarFacturas();
    setState(
        () {}); // Actualizar el estado para que se vuelva a construir el widget con la nueva información
  }

  Future<List<Factura>> cargarFacturas() async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        "select f.id_factura, to_char(f.fecha_emision, 'DD/MM/YYYY') AS fecha, f.ced_cli, c.nom_cli, c.ape_cli, fp.tip_pag, m.ced_emp_ati,m.id_ped, m.tot_ped from facturas AS f inner join maestro_pedidos as m on f.id_ped_per= m.id_ped inner join formaspago as fp on f.id_ped_per= m.id_ped and f.id_pag= fp.id_pag inner join clientes as c on f.id_ped_per= m.id_ped and f.id_pag= fp.id_pag and  c.ced_cli=f.ced_cli;");
    final List<Factura> listaFacturas = results.map((row) {
      return Factura(
          id: int.parse(row[0].toString()),
          fecha: row[1].toString(),
          cedcli: row[2].toString(),
          cliente: '${row[3]} ${row[4]}',
          tipopago: row[5].toString(),
          empleado: row[6].toString(),
          pedido: int.parse(row[7].toString()),
          total: double.parse(row[8].toString()));
    }).toList();

    await connection.close();

    return listaFacturas;
  }

  Future<List<Producto>> cargarProductos(int pedido) async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        "select p.nom_pro, d.can_pro_ped from productos as p inner join detalle_pedidos as d on d.id_ped_per= $pedido and d.id_pro_ped=p.id_pro;");
    final List<Producto> listaProductos = results.map((row) {
      return Producto(
          nombre: row[0].toString(), cantidad: int.parse(row[1].toString()));
    }).toList();

    await connection.close();

    return listaProductos;
  }
}
