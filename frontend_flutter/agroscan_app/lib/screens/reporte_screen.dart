import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_services.dart'; 
import '../models/animal_models.dart';// Tu modelo de Animal

class ReporteScreen extends StatefulWidget {
  const ReporteScreen({super.key});

  @override
  State<ReporteScreen> createState() => _ReporteScreenState();
}

class _ReporteScreenState extends State<ReporteScreen> {
  // Aquí guardaremos el conteo real: {"Holstein": 5, "Jersey": 2...}
  Map<String, int> conteoReal = {};
  bool cargando = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    obtenerDatosReales();
  }

  Future<void> obtenerDatosReales() async {
    try {
      // 1. Llamamos a tu API que ya trae los datos de Render/MongoDB
      List<Animal> listaAnimales = await ApiService().obtenerTodoElGanado();

      // 2. Lógica de procesamiento de datos (Agrupamiento por raza)
      Map<String, int> mapaTemporal = {};
      
      for (var animal in listaAnimales) {
        String raza = animal.raza.trim().toLowerCase();

        if (raza.isEmpty) {
          raza = "sin raza";
        }

        mapaTemporal[raza] = (mapaTemporal[raza] ?? 0) + 1;
      }

      setState(() {
        conteoReal = mapaTemporal;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        errorMsg = "Error al conectar con el servidor";
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reporte en Tiempo Real 📊")),
      body: _construirCuerpo(),
    );
  }

  Widget _construirCuerpo() {
    if (cargando) return const Center(child: CircularProgressIndicator());
    if (errorMsg != null) return Center(child: Text(errorMsg!));
    if (conteoReal.isEmpty) return const Center(child: Text("No hay datos para mostrar"));

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text("Distribución Actual en Base de Datos", 
               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: (conteoReal.values.reduce((a, b) => a > b ? a : b) + 2).toDouble(),
                barGroups: _generarBarrasDesdeBD(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= conteoReal.keys.length) return const Text("");
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            conteoReal.keys.elementAt(value.toInt()),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: true, drawVerticalLine: false),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _listaDetallada(),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generarBarrasDesdeBD() {
    int index = 0;
    return conteoReal.entries.map((entry) {
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.green.shade600,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }

  Widget _listaDetallada() {
    return Column(
      children: conteoReal.entries.map((e) => ListTile(
        leading: const Icon(Icons.label, color: Colors.green),
        title: Text(e.key),
        trailing: Text("${e.value} cabezas", style: const TextStyle(fontWeight: FontWeight.bold)),
      )).toList(),
    );
  }
}