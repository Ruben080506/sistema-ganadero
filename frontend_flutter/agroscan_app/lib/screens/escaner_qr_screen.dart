import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/animal_models.dart';
import 'detalle_animal_screen.dart';

class EscanerQRScreen extends StatefulWidget {

  final List<Animal> animales;

  EscanerQRScreen({
    required this.animales,
  });

  @override
  _EscanerQRScreenState createState() =>
      _EscanerQRScreenState();
}

class _EscanerQRScreenState
    extends State<EscanerQRScreen> {

  MobileScannerController cameraController =
      MobileScannerController();

  bool encontrado = false;



  // ======================================
  // PROCESAR QR
  // ======================================

  void _procesarQR(String codigoDetectado) {

    if (encontrado) return;

    encontrado = true;

    final String busqueda =
        codigoDetectado
            .trim()
            .toUpperCase();

    print("QR detectado: $busqueda");

    try {

      final vacaEncontrada =
          widget.animales.firstWhere(

        (v) => v.codigoQR
            .trim()
            .toUpperCase() ==
            busqueda,

      );


      /// ✅ ABRIR DETALLE DIRECTO

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
              DetalleAnimalScreen(
            animal: vacaEncontrada,
          ),
        ),
      );

    } catch (e) {

      encontrado = false;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
              "❌ Arete no registrado: $busqueda"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }



  // ======================================
  // UI
  // ======================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "Escanear Arete",
        ),

        actions: [

          IconButton(

            icon: Icon(Icons.flash_on),

            onPressed: () =>
                cameraController
                    .toggleTorch(),
          ),
        ],
      ),


      body: MobileScanner(

        controller:
            cameraController,

        onDetect: (capture) {

          final List<Barcode> barcodes =
              capture.barcodes;

          if (barcodes.isNotEmpty) {

            final String? code =
                barcodes
                    .first
                    .rawValue;

            if (code != null) {

              _procesarQR(code);

            }
          }
        },
      ),
    );
  }



  @override
  void dispose() {

    cameraController.dispose();

    super.dispose();
  }
}