import 'package:flutter/material.dart';

// ignore: camel_case_types
class empleado extends StatefulWidget {
  final String _cedula;
  final String _name;
  final String _apellido;
  const empleado(this._cedula, this._name, this._apellido, {super.key});
  @override
  State<empleado> createState() => _empleadoState();
}

// ignore: camel_case_types
class _empleadoState extends State<empleado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Ventana'),
      ),
      body: Center(
        child: Text(
          'Bienvenido ${widget._cedula} ${widget._name} ${widget._apellido}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
