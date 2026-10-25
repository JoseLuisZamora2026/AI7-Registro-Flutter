
import 'dart:convert';

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
      title: 'Universo de Superhéroes',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F5FA),
      ),
      home: const SuperheroesPage(),
    );
  }
}

class Superheroe {
  final String imagen;
  final String nombre;
  final String identidad;
  final String descripcion;

  const Superheroe({
    required this.imagen,
    required this.nombre,
    required this.identidad,
    required this.descripcion,
  });

  factory Superheroe.fromJson(Map<String, dynamic> json) {
    return Superheroe(
      imagen: json['imagen'] as String,
      nombre: json['nombre'] as String,
      identidad: json['identidad'] as String,
      descripcion: json['descripcion'] as String,
    );
  }
}

class SuperheroesPage extends StatefulWidget {
  const SuperheroesPage({super.key});

  @override
  State<SuperheroesPage> createState() => _SuperheroesPageState();
}

class _SuperheroesPageState extends State<SuperheroesPage> {
  late Future<List<Superheroe>> superheroesFuture;
  String busqueda = '';

  @override
  void initState() {
    super.initState();
    superheroesFuture = cargarSuperheroes();
  }

  Future<List<Superheroe>> cargarSuperheroes() async {
    final contenido = await rootBundle.loadString('lib/superheroes.json');
    final List<dynamic> datos = jsonDecode(contenido) as List<dynamic>;

    return datos
        .map(
          (elemento) => Superheroe.fromJson(
            elemento as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Widget construirImagen(Superheroe heroe) {
    final esLocal = heroe.imagen.startsWith('lib/assets/');

    if (esLocal) {
      return Image.asset(
        heroe.imagen,
        width: double.infinity,
        height: 220,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error al cargar imagen local: ${heroe.imagen}');
          debugPrint('$error');
          return imagenNoDisponible();
        },
      );
    }

    return Image.network(
      heroe.imagen,
      width: double.infinity,
      height: 220,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error al cargar imagen de red: ${heroe.imagen}');
        debugPrint('$error');
        return imagenNoDisponible();
      },
    );
  }

  Widget imagenNoDisponible() {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.indigo.shade50,
      child: const Icon(
        Icons.broken_image,
        size: 90,
        color: Colors.indigo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universo de Superhéroes'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Superheroe>>(
        future: superheroesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No se pudo cargar el JSON.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final superheroes = snapshot.data ?? [];

          final filtrados = superheroes.where((heroe) {
            final texto = busqueda.toLowerCase();

            return heroe.nombre.toLowerCase().contains(texto) ||
                heroe.identidad.toLowerCase().contains(texto);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (valor) {
                    setState(() {
                      busqueda = valor;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar superhéroe o identidad...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '${filtrados.length} de ${superheroes.length} superhéroes',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo,
                  ),
                ),
              ),
              Expanded(
                child: filtrados.isEmpty
                    ? const Center(
                        child: Text('No se encontraron personajes.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filtrados.length,
                        itemBuilder: (context, index) {
                          final heroe = filtrados[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            clipBehavior: Clip.antiAlias,
                            elevation: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 220,
                                  width: double.infinity,
                                  child: construirImagen(heroe),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        heroe.nombre,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Identidad secreta: ${heroe.identidad}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        heroe.descripcion,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
