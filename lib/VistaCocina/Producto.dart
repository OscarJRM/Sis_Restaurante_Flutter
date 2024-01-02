// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class Producto {
  String id;
  String nombre;
  double precio;
  String descripcion;
  String imagenUrl;
  String estado;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.imagenUrl,
    required this.estado,
  });
}

class ProductoWidget extends StatefulWidget {
  final Producto producto;

  ProductoWidget({required this.producto});

  @override
  _ProductoWidgetState createState() => _ProductoWidgetState();
}

class _ProductoWidgetState extends State<ProductoWidget> {
  String estado = 'Espera'; // Estado inicial

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 129, 116, 116).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(widget.producto.imagenUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.producto.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Precio: \$${widget.producto.precio.toString()}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Descripción: ${widget.producto.descripcion}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cambiar el estado del producto
                  setState(() {
                    if (estado == 'Espera') {
                      estado = 'Preparando';
                    } else if (estado == 'Preparando') {
                      estado = 'Listo';
                    } else {
                      estado = 'Espera';
                    }

                    // Aquí puedes almacenar el estado en una variable si es necesario
                    print('Estado actual del producto: $estado');
                  });
                },
                child: Text('Cambiar Estado: $estado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaProductos extends StatefulWidget {
  final List<Producto> productos;

  ListaProductos({required this.productos});

  @override
  _ListaProductosState createState() => _ListaProductosState();
}

class _ListaProductosState extends State<ListaProductos> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.productos.length,
      itemBuilder: (context, index) {
        return ProductoWidget(producto: widget.productos[index]);
      },
    );
  }
}
