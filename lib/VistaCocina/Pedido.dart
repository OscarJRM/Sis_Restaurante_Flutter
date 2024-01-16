// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../BaseDatos/conexion.dart';
import 'Producto.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:soundpool/soundpool.dart';

class Pedido {
  int id;
  DateTime fechaHora;
  double total;
  String cedulaEmpleado;
  int numeroMesa;
  String idEstadoPedido;
  List<Producto> productos;

  Pedido({
    required this.id,
    required this.fechaHora,
    required this.total,
    required this.cedulaEmpleado,
    required this.numeroMesa,
    required this.idEstadoPedido,
    required this.productos,
  });
}

class PedidoWidget extends StatefulWidget {
  final Pedido pedido;

  const PedidoWidget({Key? key, required this.pedido}) : super(key: key);

  @override
  State<PedidoWidget> createState() => _PedidoWidgetState();
}

class _PedidoWidgetState extends State<PedidoWidget> {
  String _estadoPedido(String estado) {
    if (estado == 'PEN' || estado == 'ENV') {
      return 'Pendiente';
    } else if (estado == 'PRE') {
      return 'Preparando';
    } else {
      return 'Listo';
    }
  }

  String _fechaHoraPedido(DateTime fechaHora) {
    String formattedDateTime =
        DateFormat('HH:mm:ss dd-MM-yyyy').format(fechaHora);
    return formattedDateTime;
  }

  _connectSocket() {
    final globalState = Provider.of<GlobalState>(context, listen: false);

    globalState.socket?.onConnect((data) => print('Connected+'));
    globalState.socket?.onConnectError((data) => print('Error $data'));
    globalState.socket?.onDisconnect((data) => print('Disconnected'));
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          final globalState = Provider.of<GlobalState>(context, listen: false);
          globalState.updateMesa(widget.pedido.numeroMesa);
          globalState.updateCedEmpAti(widget.pedido.cedulaEmpleado);
          _mostrarProductos(context, widget.pedido.id);
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 114, 75, 68),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pedido #${widget.pedido.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fecha y Hora: ${_fechaHoraPedido(widget.pedido.fechaHora)}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                /*Text(
                  'Total: \$${pedido.total.toString()}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),*/
                Text(
                  'C.I. Mesero: ${widget.pedido.cedulaEmpleado}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                Text(
                  'Número de Mesa: ${widget.pedido.numeroMesa}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                Text(
                  'Estado: ${_estadoPedido(widget.pedido.idEstadoPedido)}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _mostrarProductos(BuildContext context, int pedidoId) async {
    _connectSocket();
    final _productosController = StreamController<List<Producto>>();

    List<Producto> productos = await cargarProductos(pedidoId);
    _productosController.add(productos);

    // Escuchar el evento "message" en el contexto actual
    final globalState = Provider.of<GlobalState>(context, listen: false);
    globalState.socket?.on("message", (data) async {
      print(data);
      productos = await cargarProductos(pedidoId);
      _productosController
          .add(productos); // Agrega los nuevos productos al stream
      if (mounted) {
        setState(() {
          print("carga pedidos");
        });
        print("carga");
      }
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Productos del Pedido #$pedidoId'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<List<Producto>>(
              stream: _productosController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListaProductos(productos: snapshot.data!);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
    @override
    void dispose() {
      _productosController
          .close(); // Asegúrate de cerrar el controlador al finalizar
      super.dispose();
    }
  }

  Future<List<Producto>> cargarProductos(int pedidoId) async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        'SELECT p.*, dp.est_pro_ped, dp.id_ped_per, dp.can_pro_ped FROM DETALLE_PEDIDOS dp JOIN PRODUCTOS p ON dp.ID_PRO_PED = p.ID_PRO WHERE dp.ID_PED_PER = $pedidoId');

    final List<Producto> productosList = results.map((row) {
      return Producto(
          id: row[0].toString(),
          nombre: row[1].toString(),
          precio: double.parse(row[2].toString()),
          descripcion: row[3].toString(),
          imagenUrl: row[4].toString(),
          estado: row[6].toString(),
          idPedidoPertenece: int.parse(row[7].toString()),
          cantidad: int.parse(row[8].toString()));
    }).toList();

    await connection.close();

    return productosList;
  }
}

class ListaPedidos extends StatefulWidget {
  final void Function(Pedido) onPedidoTap;

  const ListaPedidos({Key? key, required this.onPedidoTap}) : super(key: key);

  @override
  _ListaPedidosState createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  List<Pedido> pedidos = [];
  late IO.Socket _socket;

  _sendMessage(String pedido) {
    _socket.emit('message', {'message': pedido, 'sender': "cocina"});
  }

  _connectSocket() {
    _socket.onConnect((data) => print('Connected+'));
    _socket.onConnectError((data) => print('Error $data'));
    _socket.onDisconnect((data) => print('Disconnected'));
    int i = 0;
    _socket.on("message", (data) {
      print(data);
      int idePed = data['idPed'];
      if (mounted) {
        setState(() {
          cargarPedidos();
          print("carga");
          String pedido = data['message'];
          String? nombre = data['nombre'];
          if (nombre == null) {
            if (pedido == "Enviado") {
              _mostrarSnackbar(context, "Pedido #$idePed entrante!");
            } else if (pedido == "Terminado") {
              _mostrarSnackbar(context, "Pedido #$idePed Despachado!");
            }
          }

          //_sound();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _socket = IO.io(
        'https://sistemarestaurante.webpubsub.azure.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath("/clients/socketio/hubs/Centro")
            .setQuery({'username': "cocina"})
            .build());
    _connectSocket();
    final globalState = Provider.of<GlobalState>(context, listen: false);
    globalState.updatesocket(_socket);
    cargarPedidos();
  }

  Future<void> cargarPedidos() async {
    print("Cargando pedidos");
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        "SELECT * FROM MAESTRO_PEDIDOS WHERE id_est_ped != 'DES' order by id_ped ASC");

    final List<Pedido> pedidosList = results.map((row) {
      return Pedido(
        id: int.parse(row[0].toString()),
        fechaHora: row[1] as DateTime,
        total: double.parse(row[2].toString()),
        cedulaEmpleado: row[3].toString(),
        numeroMesa: int.parse(row[4].toString()),
        idEstadoPedido: row[5].toString(),
        productos: [],
      );
    }).toList();

    setState(() {
      pedidos = pedidosList;
    });

    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        return PedidoWidget(pedido: pedidos[index]);
      },
    );
  }
}

class ListaProductosPedido extends StatefulWidget {
  final Pedido pedido;

  const ListaProductosPedido({Key? key, required this.pedido})
      : super(key: key);

  @override
  _ListaProductosPedidoState createState() => _ListaProductosPedidoState();
}

class _ListaProductosPedidoState extends State<ListaProductosPedido> {
  List<Producto> productos = [];
  _connectSocket() {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    print("2");
    globalState.socket?.onConnect((data) => print('Connected+'));
    globalState.socket?.onConnectError((data) => print('Error $data'));
    globalState.socket?.onDisconnect((data) => print('Disconnected'));

    globalState.socket?.on("message", (data) {
      print(data);
      if (mounted) {
        setState(() {
          print("carga pedidos");
          cargarProductosPedido();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
    print("1");
    cargarProductosPedido();
  }

  Future<void> cargarProductosPedido() async {
    final connection = await DatabaseConnection.instance.openConnection();
    final results = await connection.execute(
        'SELECT p.*, dp.est_pro_ped, dp.id_ped_per, dp.can_pro_ped FROM DETALLE_PEDIDOS dp JOIN PRODUCTOS p ON dp.ID_PRO_PED = p.ID_PRO WHERE dp.ID_PED_PER = ${widget.pedido.id}');

    final List<Producto> productosList = results.map((row) {
      return Producto(
          id: row[0].toString(),
          nombre: row[1].toString(),
          precio: double.parse(row[2].toString()),
          descripcion: row[3].toString(),
          imagenUrl: row[4].toString(),
          estado: row[6].toString(),
          idPedidoPertenece: int.parse(row[7].toString()),
          cantidad: int.parse(row[8].toString()));
    }).toList();

    setState(() {
      print("Si");
      productos = productosList;
    });

    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: productos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: ProductoWidget(producto: productos[index]),
        );
      },
    );
  }
}

_mostrarSnackbar(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      backgroundColor: Colors.green,
    ),
  );
}

Future<void> _sound() async {
  Soundpool pool = Soundpool(streamType: StreamType.notification);
  int soundId = await rootBundle
      .load("assets/Audio/notify.mp3")
      .then((ByteData soundData) {
    return pool.load(soundData);
  });
  int streamId = await pool.play(soundId);
}
