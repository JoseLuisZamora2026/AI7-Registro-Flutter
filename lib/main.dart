
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de usuario',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F5FA),
      ),
      home: const Registro(),
    );
  }
}

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formKey = GlobalKey<FormState>();

  final nombre = TextEditingController();
  final paterno = TextEditingController();
  final materno = TextEditingController();
  final correo = TextEditingController();
  final telefono = TextEditingController();
  final password = TextEditingController();
  final confirmar = TextEditingController();

  bool ocultarPassword = true;
  bool ocultarConfirmacion = true;

  @override
  void dispose() {
    nombre.dispose();
    paterno.dispose();
    materno.dispose();
    correo.dispose();
    telefono.dispose();
    password.dispose();
    confirmar.dispose();
    super.dispose();
  }

  String? validarNombre(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]+$')
        .hasMatch(valor.trim())) {
      return 'Escribe solo letras';
    }

    return null;
  }

  String? validarCorreo(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Ingresa tu correo electrónico';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(valor.trim())) {
      return 'El correo no es válido';
    }

    return null;
  }

  String? validarTelefono(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Ingresa tu número celular';
    }

    if (valor.length != 10) {
      return 'El teléfono debe tener 10 dígitos';
    }

    return null;
  }

  String? validarPassword(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Ingresa una contraseña';
    }

    if (valor.length < 8) {
      return 'Usa al menos 8 caracteres';
    }

    return null;
  }

  Widget crearCampo(
    String etiqueta,
    TextEditingController controlador, {
    TextInputType tipo = TextInputType.text,
    String? Function(String?)? validar,
    List<TextInputFormatter>? filtros,
    bool oculto = false,
    Widget? icono,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controlador,
        keyboardType: tipo,
        obscureText: oculto,
        validator: validar,
        inputFormatters: filtros,
        decoration: InputDecoration(
          labelText: etiqueta,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: icono,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void registrar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro validado correctamente'),
        ),
      );
    }
  }

  void limpiar() {
    _formKey.currentState!.reset();

    nombre.clear();
    paterno.clear();
    materno.clear();
    correo.clear();
    telefono.clear();
    password.clear();
    confirmar.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.indigo,
              child: Icon(
                Icons.person,
                size: 52,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Crear cuenta',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Completa tus datos para registrarte',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),

            crearCampo(
              'Nombre',
              nombre,
              validar: validarNombre,
              filtros: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]'),
                ),
              ],
            ),
            crearCampo(
              'Apellido paterno',
              paterno,
              validar: validarNombre,
              filtros: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]'),
                ),
              ],
            ),
            crearCampo(
              'Apellido materno',
              materno,
              validar: validarNombre,
              filtros: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]'),
                ),
              ],
            ),
            crearCampo(
              'Correo electrónico',
              correo,
              tipo: TextInputType.emailAddress,
              validar: validarCorreo,
            ),
            crearCampo(
              'Teléfono celular',
              telefono,
              tipo: TextInputType.phone,
              validar: validarTelefono,
              filtros: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            crearCampo(
              'Contraseña',
              password,
              oculto: ocultarPassword,
              validar: validarPassword,
              icono: IconButton(
                icon: Icon(
                  ocultarPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    ocultarPassword = !ocultarPassword;
                  });
                },
              ),
            ),
            crearCampo(
              'Confirmar contraseña',
              confirmar,
              oculto: ocultarConfirmacion,
              validar: (valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Confirma tu contraseña';
                }

                if (valor != password.text) {
                  return 'Las contraseñas no coinciden';
                }

                return null;
              },
              icono: IconButton(
                icon: Icon(
                  ocultarConfirmacion
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    ocultarConfirmacion = !ocultarConfirmacion;
                  });
                },
              ),
            ),

            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: registrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Registrarme'),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: limpiar,
              child: const Text('Limpiar formulario'),
            ),
          ],
        ),
      ),
    );
  }
}
