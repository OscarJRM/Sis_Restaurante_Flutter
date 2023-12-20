import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import 'productosMesero.dart';
import 'package:badges/badges.dart' as badges;

class TabBarProductos extends StatefulWidget {
  const TabBarProductos({super.key});

  @override
  State<TabBarProductos> createState() => _TabBarProductosState();
}

class _TabBarProductosState extends State<TabBarProductos>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: const TabBarView(
          children:[
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
    );
  }
}
