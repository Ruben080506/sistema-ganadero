import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/animal_models.dart';
import '../services/api_services.dart';

import 'detalle_animal_screen.dart';
import 'escaner_qr_screen.dart';

class HistorialScreen extends StatefulWidget {
  @override
  _HistorialScreenState createState() =>
      _HistorialScreenState();
}

class _HistorialScreenState
    extends State<HistorialScreen> {

  final _dbHelper = DBHelper();
  final _apiService = ApiService();

  List<Animal> _animalesSincronizados = [];


  // ============================================
  // INIT
  // ============================================

  @override
  void initState() {
    super.initState();

    print("DEBUG: Entrando a la pantalla de Historial...");

    _cargarHistorial();
  }


  // ============================================
  // ESCANEO QR (NUEVO)
  // ============================================

  void _iniciarEscaneo() {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (context) =>

            EscanerQRScreen(
              animales: _animalesSincronizados,
            ),
      ),
    );
  }


  // ============================================
  // SINCRONIZACIÓN FORZADA
  // ============================================

  void _cargarHistorial() async {

    print("--- INTENTO DE CONEXIÓN INICIADO ---");

    try {

      List<Animal> desdeNube =
          await _apiService.obtenerTodoElGanado();

      print(
          "--- DATOS RECIBIDOS API: ${desdeNube.length} animales ---");

      if (desdeNube.isNotEmpty) {

        setState(() {
          _animalesSincronizados =
              desdeNube;
        });

        for (var a in desdeNube) {

          await _dbHelper.insertarAnimal(a);

        }

        final totalLocal =
            await _dbHelper
                .obtenerSincronizados();

        print(
            "--- AHORA SQLITE TIENE: ${totalLocal.length} animales ---");
      }

    } catch (e) {

      print("Error: $e");

      final local =
          await _dbHelper
              .obtenerSincronizados();

      setState(() {
        _animalesSincronizados = local;
      });
    }
  }


  // ============================================
  // REFRESH
  // ============================================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarHistorial();
  }


  // ============================================
  // UI (MISMO DISEÑO)
  // ============================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Historial en la Nube"),
        backgroundColor: Colors.blueGrey,
      ),

      body:
          _animalesSincronizados.isEmpty
              ? Center(
                  child: Text(
                    "No hay vacas sincronizadas",
                  ),
                )
              : ListView.builder(

                  itemCount:
                      _animalesSincronizados.length,

                  itemBuilder:
                      (context, index) {

                    final animal =
                        _animalesSincronizados[index];

                    return ListTile(

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (context) =>
                                DetalleAnimalScreen(
                              animal: animal,
                            ),
                          ),
                        );
                      },

                      leading: Icon(
                        Icons.cloud_done,
                        color: Colors.green,
                      ),

                      title: Text(
                        "Arete: ${animal.codigoQR}",
                      ),

                      subtitle: Text(
                        "${animal.raza} - Registro Permanente",
                      ),

                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    );
                  },
                ),

      floatingActionButton:
          FloatingActionButton(

        onPressed: _iniciarEscaneo,

        backgroundColor: Colors.orange,

        child: Icon(
          Icons.qr_code_scanner,
        ),
      ),
    );
  }
}