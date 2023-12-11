import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:postgres/postgres.dart';
import 'package:sistema_restaurante/src/conexion.dart';
import 'package:sistema_restaurante/src/empleado.dart';

/*
dependecias:
flutter pub add postgres
flutter pub add google_fonts
*/

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late String _email;
  late String _password;
  bool _isEmailValid = false;
  bool _obscureText = true;
  String _emailError = ' ';

  _submit() {
    final isLogin = _formKey.currentState?.validate();
    isLogin;
  }

  _submitButton() {
    final isLogin = _formKey.currentState?.validate();
    return isLogin;
  }

  Future<bool> ingresar(String email, String pass) async {
    final dataBase = ConexionDB();

    try {
      Connection? conn = await dataBase.connect();
      final result = await conn?.execute(
          "SELECT * FROM empleados WHERE usu_emp= '$email' AND con_emp= '$pass'");
      if (result!.isNotEmpty) {
        if (kDebugMode) {
          print('el empleado existe');
        }
        setState(() {
          _emailError = ' ';
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => empleado(result[0][0] as String,
                  result[0][1] as String, result[0][2] as String)),
        );
        return true;
      } else {
        setState(() {
          _emailError = 'El usuario o la contraseña son incorrectos';
        });
        if (kDebugMode) {
          print('el empleado no existe');
        }
      }
      await dataBase.close();
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image:
                      AssetImage('images/5519b98abccc5bd0cfb6170d1bd92907.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 90,
                ),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 100.0,
                        backgroundColor: Colors.deepOrange[100],
                        backgroundImage:
                            const AssetImage('images/2023-03-18.jpg'),
                      ),
                      Text(
                        'Doble Filo',
                        style: GoogleFonts.getFont('Pacifico',
                            fontSize: 50.0,
                            color: const Color.fromARGB(255, 241, 177, 15)),
                      ),
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                            fontSize: 21.0,
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 241, 177, 15)),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 35.0,
                        child: Divider(
                          color: Colors.green[100],
                          thickness: 2.0,
                        ),
                      ),
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            TextFormField(
                              enableInteractiveSelection: false,
                              autofocus: true,
                              style: TextStyle(color: Colors.lightBlue[50]),
                              keyboardType: TextInputType.emailAddress,
                              focusNode: _submit(),
                              decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.lightBlue[50]),
                                hintText: 'EMAIL',
                                labelText: 'Correo Electrónico',
                                labelStyle:
                                    TextStyle(color: Colors.lightBlue[50]),
                                suffixIcon: Icon(Icons.verified_user_outlined,
                                    color: Colors.lightBlue[50]),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                              onChanged: (data) {
                                _email = data;
                                setState(() {
                                  RegExp regex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  _isEmailValid = regex.hasMatch(data);
                                });
                              },
                              validator: (data) {
                                if (!_isEmailValid) {
                                  return 'Ingrese un correo válido';
                                }
                                return null;
                              },
                            ),
                            Text(
                              _emailError,
                              style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color.fromARGB(255, 181, 33, 22)),
                            ),
                            const Divider(
                              color: Colors.transparent,
                              height: 20.0,
                            ),
                            TextFormField(
                              enableInteractiveSelection: false,
                              style: TextStyle(color: Colors.lightBlue[50]),
                              focusNode: _submit(),
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.lightBlue[50]),
                                hintText: 'CONTRASEÑA',
                                labelText: 'Contraseña',
                                labelStyle:
                                    TextStyle(color: Colors.lightBlue[50]),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    color: Colors.lightBlue[50],
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onChanged: (data) {
                                _password = data;
                                setState(() {});
                              },
                              validator: (data) {
                                if (data!.trim().isEmpty) {
                                  return 'Ingrese una contraseña valida';
                                }
                                return null;
                              },
                            ),
                            const Divider(
                              height: 30,
                              color: Colors.transparent,
                            ),
                            SizedBox(
                                width: 175.0,
                                height: 55.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        const Color.fromARGB(255, 225, 178, 35),
                                    backgroundColor:
                                        Color.fromARGB(255, 1, 1, 1),
                                  ),
                                  onPressed: () {
                                    if (_submitButton()) {
                                      ingresar(_email, _password);
                                    }
                                  },
                                  child: Text('Iniciar Sesión',
                                      style: GoogleFonts.taviraj(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 243, 136, 49),
                                      )),
                                ))
                          ]))
                    ],
                  )
                ],
              ),
            )));
  }
}
