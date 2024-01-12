import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import 'package:postgres/postgres.dart';
import 'productosMesero.dart';
import '../BaseDatos/conexion.dart';
import 'package:provider/provider.dart';
import '../models/platos.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sistema_restaurante/models/vGlobal.dart';

class Mesero extends StatelessWidget {
  const Mesero({super.key});

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
            badges.Badge(
              badgeContent: Text(
                '',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              child: Icon(Icons.shopping_bag, color: Colors.white),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Color(0xFFE57734),
              ),
            ),
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
      future: buscarProductos(query),
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
                // Añadir un botón para agregar al carrito
                trailing: ElevatedButton(
                  onPressed: () {
                    _agregarAlCarrito(context, productos[index]);
                  },
                  child: Text('Añadir'),
                ),
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
  Future<void> _agregarAlCarrito(BuildContext context, Plato producto) async {
    final cantidad = await _mostrarDialogoCantidad(context);

    if (cantidad != null && cantidad > 0) {
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

      // Mostrar notificación en el SnackBar
      final snackBar = SnackBar(
        content: Text('Producto añadido al carrito'),
        backgroundColor: Color(0xFFE57734),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

Future<List<Plato>> buscarProductos(String query) async {
  final conn = await DatabaseConnection.instance.openConnection();

  try {
    final result = await conn.execute(
        Sql.named("SELECT * FROM Productos WHERE lower(Nom_pro) LIKE @query"),
        parameters: {'query': '%${query.toLowerCase()}%'});
    print('Resultados: $result');

    // Llena la lista de platos con los resultados obtenidos
    List<Plato> listaPlatos = Platos(result);

    return listaPlatos;
  } catch (e) {
    print('Error en la búsqueda de productos: $e');
    return []; // Devuelve una lista vacía en caso de error
  } finally {
    // Cierra la conexión cuando hayas terminado de usarla
    await conn.close();
  }
}

// Función para mostrar el AlertDialog y obtener la cantidad
Future<int?> _mostrarDialogoCantidad(BuildContext context) async {
  int? cantidad;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ingrese la cantidad'),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            cantidad = int.tryParse(value);
            if (cantidad != null) {
              // Validación para asegurarte de que la cantidad sea mayor a 0
              cantidad = cantidad! > 0 ? cantidad : null;
            }
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
              if (cantidad != null) {
                Navigator.of(context).pop(cantidad);
              } else {
                // Muestra un mensaje de error si la cantidad no es válida
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('La cantidad debe ser mayor que 0'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );

  return cantidad;
}

