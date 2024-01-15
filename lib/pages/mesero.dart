import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import 'package:postgres/postgres.dart';
import 'productosMesero.dart';
import '../BaseDatos/conexion.dart';
import 'package:provider/provider.dart';
import '../models/platos.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sistema_restaurante/models/vGlobal.dart';

class Mesero extends StatefulWidget {
  const Mesero({super.key});

  @override
  State<Mesero> createState() => _MeseroState();
}

class _MeseroState extends State<Mesero> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 106, right: 20),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/carrito');
            },
            backgroundColor: const Color(0xFFE57734),
            child: const Stack(
              children: [
                SizedBox(
                  height: 35,
                  width: 35,
                  child: Icon(Icons.shopping_cart),
                ),
                Positioned(
                  top: 1,
                  right: 1,
                  child: CircleAvatar(
                    radius: 8,
                    child: Text("", style: TextStyle(fontSize: 12)),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 26, 27, 29),
          title: const Text(
            "Menú",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            SizedBox(width: 20.0),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(context: context, delegate: ProductSearch());
              },
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 44),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBarView(
            children: [
              // Contenido de la pestaña 1
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ProductosMesero(),
                    ),
                    // Puedes agregar más widgets dentro de la Column si es necesario
                  ],
                ),
              ),

              // Contenido de la pestaña 2
              Center(
                child: Text(
                  'Contenido de la pestaña 2',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Nuevo widget para manejar la búsqueda de productos
class ProductSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Plato>>(
      future: buscarProductos(context, query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Plato> productos = snapshot.data ?? [];
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(productos[index].nomPro,
                    style: TextStyle(color: Colors.white)),
                subtitle: Text('Precio: ${productos[index].preUni}',
                    style: TextStyle(color: Colors.white)),
                // Añadir un botón para agregar al carrito solo si no está agregado
                trailing: productos[index].agregadoAlCarrito
                    ? ElevatedButton(
                        onPressed: () {},
                        child: Text('Agregado al carrito',
                            style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            mouseCursor: MaterialStateProperty.all(
                                SystemMouseCursors.click),
                            minimumSize:
                                MaterialStateProperty.all(Size(100, 40)),
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFFE57734))))
                    : ElevatedButton(
                        onPressed: () async {
                          final cantidad =
                              await _mostrarDialogoCantidad(context);
                          if (cantidad != null && cantidad > 0) {
                            _agregarAlCarrito(
                                context, productos[index], cantidad);
                          }
                        },
                        child: Text('Añadir',
                            style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            mouseCursor: MaterialStateProperty.all(
                                SystemMouseCursors.click),
                            minimumSize:
                                MaterialStateProperty.all(Size(100, 40)),
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFFE57734)))),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implementa sugerencias mientras el usuario escribe
    return Center(
      child: Text('Escribe para buscar productos'),
    );
  }

  // Función para agregar el producto al carrito
  Future<void> _agregarAlCarrito(
    BuildContext context,
    Plato producto,
    int cantidad,
  ) async {
    // Lógica para agregar al carrito
    final conn = await DatabaseConnection.instance.openConnection();
    final globalState = Provider.of<GlobalState>(context, listen: false);

    final result = await conn.execute(
      r'INSERT INTO DETALLE_PEDIDOs VALUES ($1,$2,$3,$4)',
      parameters: [
        globalState.idPed,
        producto.idPro,
        "PEN",
        cantidad,
      ],
    );

    // Actualiza la propiedad agregadoAlCarrito del producto
    producto.agregadoAlCarrito = true;

    // Mostrar notificación en el SnackBar
    final snackBar = SnackBar(
      content: Text('Producto añadido al carrito'),
      backgroundColor: Color(0xFFE57734),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Future<List<Plato>> buscarProductos(BuildContext context, String query) async {
  final conn = await DatabaseConnection.instance.openConnection();

  try {
    final result = await conn.execute(
        Sql.named("SELECT * FROM Productos WHERE lower(Nom_pro) LIKE @query"),
        parameters: {'query': '%${query.toLowerCase()}%'});

    // Llena la lista de platos con los resultados obtenidos
    List<Plato> listaPlatos = Platos(result);

    // Verifica si cada producto está en el carrito
    final globalState = Provider.of<GlobalState>(context, listen: false);
    for (var producto in listaPlatos) {
      final agregado =
          await verificarProductoAgregado(producto.idPro, globalState.idPed);
      producto.agregadoAlCarrito = agregado;
    }

    return listaPlatos;
  } catch (e) {
    print('Error en la búsqueda de productos: $e');
    return []; // Devuelve una lista vacía en caso de error
  } finally {
    // Cierra la conexión cuando hayas terminado de usarla
    await conn.close();
  }
}

// Función para verificar si un producto está en el carrito
Future<bool> verificarProductoAgregado(String idProducto, int idPedido) async {
  final conn = await DatabaseConnection.instance.openConnection();

  try {
    final result = await conn.execute(
      'SELECT COUNT(*) FROM DETALLE_PEDIDOS WHERE ID_PED_PER = \$1 AND ID_PRO_PED = \$2',
      parameters: [idPedido, idProducto],
    );
    debugPrint(result.toString());
    return result.isNotEmpty &&
        result[0][0] != null &&
        (result[0][0]! as int) > 0;
  } catch (e) {
    print('Error al verificar producto en el carrito: $e');
    return false;
  } finally {
    // Cierra la conexión cuando hayas terminado de usarla
    await conn.close();
  }
}

// Función para mostrar el AlertDialog y obtener la cantidad
Future<int?> _mostrarDialogoCantidad(BuildContext context) async {
  int?
      cantidad; // Usar un nullable int para distinguir si el usuario presionó "Cancelar"

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      TextEditingController cantidadController = TextEditingController();
      cantidadController.text = '1';

      return AlertDialog(
        title: Text('Ingrese la cantidad'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          int current =
                              int.tryParse(cantidadController.text) ?? 1;
                          if (current > 1) {
                            setState(() {
                              cantidadController.text =
                                  (current - 1).toString();
                            });
                          }
                        },
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 50,
                        child: TextField(
                          controller: cantidadController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          int current =
                              int.tryParse(cantidadController.text) ?? 1;
                          setState(() {
                            cantidadController.text = (current + 1).toString();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              int inputCantidad = int.tryParse(cantidadController.text) ?? 0;
              if (inputCantidad > 0) {
                cantidad = inputCantidad;
              } else {
                // Muestra un mensaje de error si la cantidad no es válida
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('La cantidad debe ser mayor que 0'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              Navigator.of(context).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );

  return cantidad;
}
