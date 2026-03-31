import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/animal_models.dart';

class ApiService {

  static const String baseUrl =
      "https://sistema-ganadero.onrender.com";


  // =========================================================
  // 1. OBTENER TODO EL GANADO
  // =========================================================

  Future<List<Animal>> obtenerTodoElGanado() async {

    try {

      final response =
          await http.get(
        Uri.parse("$baseUrl/ganado/"),
      );

      print("STATUS: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {

        print("BODY RECIBIDO:");
        print(response.body);

        List<dynamic> body =
            jsonDecode(response.body);

        return body
            .map((item) =>
                Animal.fromMap(item))
            .toList();
      }

      print("ERROR SERVER:");
      print(response.body);

      return [];

    } catch (e) {

      print(
          "Error al conectar con el servidor: $e");

      return [];
    }
  }


  // =========================================================
  // 2. SINCRONIZAR
  // =========================================================

  Future<bool> sincronizarConBackend(
      List<Animal> pendientes) async {

    try {

      List<Map<String, dynamic>> data =
          pendientes
              .map((a) => a.toMap())
              .toList();

      final response = await http.post(

        Uri.parse("$baseUrl/ganado/sync"),

        headers: {
          "Content-Type":
              "application/json"
        },

        body: jsonEncode(data),
      );

      print("SYNC STATUS: ${response.statusCode}");
      print("SYNC BODY: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {

        print(
            ">>> Sincronización exitosa <<<");

        return true;

      } else {

        print(
            "Error servidor: ${response.body}");

        return false;
      }

    } catch (e) {

      print("Error red: $e");

      return false;
    }
  }


  // =========================================================
  // 3. HISTORIAL
  // =========================================================

  Future<Map<String, dynamic>?>
      obtenerHistorial(String qr) async {

    try {

      final response =
          await http.get(

        Uri.parse(
          "$baseUrl/ganado/$qr/historial",
        ),
      );

      print("HISTORIAL STATUS: ${response.statusCode}");
      print("HISTORIAL BODY: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {

        return jsonDecode(
            response.body);
      }

      return null;

    } catch (e) {

      print(
          "Error historial: $e");

      return null;
    }
  }


  // =========================================================
  // 4. VACUNA
  // =========================================================

  Future<bool> registrarVacuna(

    String qr,
    String nombre,
    String dosis,

  ) async {

    try {

      final response =
          await http.post(

        Uri.parse(
            "$baseUrl/ganado/$qr/vacuna"),

        headers: {
          "Content-Type":
              "application/json"
        },

        body: jsonEncode({

          "tipo": nombre,
          "dosis": dosis,

        }),
      );

      print("VACUNA STATUS: ${response.statusCode}");
      print("VACUNA BODY: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {

        print("Vacuna guardada");

        return true;

      } else {

        return false;
      }

    } catch (e) {

      print(
          "Error red vacuna: $e");

      return false;
    }
  }


  // =========================================================
  // 5. REVISION
  // =========================================================

  Future<bool> registrarRevision(

    String qr,
    String obs,
    String estado,

  ) async {

    try {

      final response =
          await http.post(

        Uri.parse(
            "$baseUrl/ganado/$qr/revision"),

        headers: {
          "Content-Type":
              "application/json"
        },

        body: jsonEncode({

          "observaciones": obs,
          "estado_salud": estado,

        }),
      );

      print("REVISION STATUS: ${response.statusCode}");
      print("REVISION BODY: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {

        print(
            "Revision guardada");

        return true;

      } else {

        return false;
      }

    } catch (e) {

      print(
          "Error red revision: $e");

      return false;
    }
  }


  // =========================================================
  // 6. ACTUALIZAR PESO (AÑADIDO)
  // =========================================================

  Future<bool> actualizarPeso(
  String codigoQR,
  double peso,
) async {

  final url =
      Uri.parse("$baseUrl/ganado/$codigoQR/peso");

  try {

    final response =
        await http.put(

      url,

      headers: {
        "Content-Type":
            "application/json"
      },

      body: jsonEncode({
        "peso": peso,
      }),
    );

    print(response.statusCode);
    print(response.body);

    return response.statusCode >= 200 && response.statusCode < 300;

  } catch (e) {

    print(e);
    return false;
  }
}

}