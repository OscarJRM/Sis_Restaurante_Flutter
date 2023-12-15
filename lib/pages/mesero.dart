import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import 'productosMesero.dart';
import 'package:badges/badges.dart' as badges;

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
          actions: const [
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
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pestaña 1'),
              Tab(text: 'Pestaña 2'),
            ],
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
