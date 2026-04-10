import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/animal_models.dart';
import '../services/api_services.dart';

class DetalleAnimalScreen extends StatefulWidget {
  final Animal animal;

  const DetalleAnimalScreen({super.key, required this.animal});

  @override
  _DetalleAnimalScreenState createState() =>
      _DetalleAnimalScreenState();
}

class _DetalleAnimalScreenState
    extends State<DetalleAnimalScreen> {

  final _apiService = ApiService();

  Map<String, dynamic>? _historial;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosMedicos();
  }

  void _cargarDatosMedicos() async {

    final datos =
        await _apiService.obtenerHistorial(
            widget.animal.codigoQR);

    setState(() {
      _historial = datos;
      _cargando = false;
    });
  }

  String _obtenerEstadoActual() {

    var clinico =
        _historial?['clinico'] as List? ?? [];

    if (clinico.isNotEmpty) {
      return clinico.first['estado_salud'] ??
          widget.animal.estadoSalud;
    }

    return widget.animal.estadoSalud;
  }

  


  void _mostrarFormularioAccion() {
    String tipoAccion = "Vacuna";

    final controller1 =
        TextEditingController();

    final controller2 =
        TextEditingController();

    showModalBottomSheet(

      context: context,
      isScrollControlled: true,

      builder: (context) {

        return StatefulBuilder(

          builder: (
            context,
            setModalState,
          ) {

            return Padding(

              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context)
                        .viewInsets
                        .bottom,
                left: 20,
                right: 20,
                top: 20,
              ),

              child: Column(

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  Row(
                    children: [
                      Icon(Icons.medical_services),
                      SizedBox(width: 8),
                      Text(
                        "Registrar Actividad",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  DropdownButton<String>(
                    value: tipoAccion,
                    isExpanded: true,
                    items: [
                      "Vacuna",
                      "Revisión"
                    ].map((value) {

                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );

                    }).toList(),

                    onChanged: (v) {

                      setModalState(() {
                        tipoAccion = v!;
                      });
                    },
                  ),

                  TextField(
                    controller:
                        controller1,
                    decoration:
                        InputDecoration(
                      labelText:
                          tipoAccion ==
                                  "Vacuna"
                              ? "Vacuna"
                              : "Observaciones",
                      prefixIcon:
                          Icon(Icons.edit),
                    ),
                  ),

                  TextField(
                    controller:
                        controller2,
                    decoration:
                        InputDecoration(
                      labelText:
                          tipoAccion ==
                                  "Vacuna"
                              ? "Dosis"
                              : "Estado",
                      prefixIcon:
                          Icon(Icons.info),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton.icon(

                    icon:
                        Icon(Icons.save),

                    label:
                        Text("Guardar"),

                    onPressed: () async {

                      bool exito =
                          false;

                      if (tipoAccion ==
                          "Vacuna") {

                        exito =
                            await _apiService
                                .registrarVacuna(

                          widget.animal
                              .codigoQR,

                          controller1.text,

                          controller2.text,
                        );

                      } else {

                        exito =
                            await _apiService
                                .registrarRevision(

                          widget.animal
                              .codigoQR,

                          controller1.text,

                          controller2.text,
                        );
                      }

                      if (exito) {

                        Navigator.pop(
                            context);

                        _cargarDatosMedicos();

                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(

                          SnackBar(
                            content: Text(
                                "Actualizado"),
                          ),
                        );
                      }
                    },
                  ),

                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarDialogoPeso() {

  TextEditingController pesoController =
      TextEditingController(
        text: widget.animal.peso.toString(),
      );

  showDialog(

    context: context,

    builder: (context) {

      return AlertDialog(

        title: Text(
          "Actualizar Peso - ${widget.animal.codigoQR}",
        ),

        content: TextField(

          controller: pesoController,

          keyboardType: TextInputType.number,

          decoration: InputDecoration(
            labelText: "Nuevo peso",
            suffixText: "kg",
          ),
        ),

        actions: [

          TextButton(

            onPressed: () {
              Navigator.pop(context);
            },

            child: Text("Cancelar"),
          ),

          ElevatedButton(

            onPressed: () async {

              double? nuevoPeso =
                  double.tryParse(
                    pesoController.text,
                  );

              if (nuevoPeso != null) {

                bool exito =
                    await _apiService
                        .actualizarPeso(
                  widget.animal.codigoQR,
                  nuevoPeso,
                );

                if (exito) {

                  setState(() {
                    widget.animal.peso =
                        nuevoPeso;
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    SnackBar(
                      content: Text(
                        "✅ Peso actualizado",
                      ),
                    ),
                  );
                }
              }
            },

            child: Text("Guardar"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
            "Ficha: ${widget.animal.codigoQR}"),
        backgroundColor:
            Colors.blueGrey,
      ),

      body: _cargando
          ? Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView(

              padding:
                  EdgeInsets.all(16),

              children: [

                _buildInfoCard(),

                SizedBox(height: 20),

                /// QR

                Card(
                  child: Padding(

                    padding:
                        EdgeInsets.all(16),

                    child: Column(

                      children: [

                        Row(
                          children: [

                            Icon(Icons.qr_code),

                            SizedBox(width: 8),

                            Text(
                              "Código QR",
                              style:
                                  TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        QrImageView(
                          data: widget
                              .animal.codigoQR,
                          size: 200,
                          backgroundColor:
                              Colors.white,
                        ),

                        Text(
                          widget
                              .animal.codigoQR,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  children: [
                    Icon(Icons.vaccines),
                    SizedBox(width: 8),
                    Text(
                      "Vacunas",
                      style:
                          TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                _buildListaVacunas(),

                SizedBox(height: 20),

                Row(
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(width: 8),
                    Text(
                      "Salud",
                      style:
                          TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                _buildListaClinica(),
              ],
            ),

      floatingActionButton:
          FloatingActionButton.extended(

        onPressed:
            _mostrarFormularioAccion,

        icon:
            Icon(Icons.medical_services),

        label:
            Text("Registrar"),
      ),
    );
  }



  Widget _buildInfoCard() {

    String estado =
        _obtenerEstadoActual();

    return Card(

      child: Column(

        children: [

          ListTile(
            leading:
                Icon(Icons.pets),
            title: Text(
                "Raza: ${widget.animal.raza}"),
          ),

          ListTile(
            leading:
                Icon(Icons.monitor_weight),
            title: Text(
                "Peso: ${widget.animal.peso}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: _mostrarDialogoPeso,
                ),
          ),

          ListTile(
            leading:
                Icon(Icons.health_and_safety),
            title:
                Text("Estado: $estado"),
          ),
        ],
      ),
    );
  }



  Widget _buildListaVacunas() {

    var vacunas =
        _historial?['vacunas']
                as List? ??
            [];

    if (vacunas.isEmpty) {
      return Text(
          "No hay vacunas");
    }

    return Column(

      children: vacunas.map(

        (v) {

          return ListTile(

            leading:
                Icon(Icons.vaccines),

            title:
                Text(v['tipo']),

            subtitle:
                Text(v['dosis']),
          );
        },
      ).toList(),
    );
  }



  Widget _buildListaClinica() {

    var clinico =
        _historial?['clinico']
                as List? ??
            [];

    if (clinico.isEmpty) {
      return Text(
          "Sin datos");
    }

    return Column(

      children: clinico.map(

        (c) {

          return ListTile(

            leading:
                Icon(Icons.description),

            title:
                Text(c['estado_salud']),

            subtitle:
                Text(c['observaciones']),
          );
        },
      ).toList(),
    );
  }
}