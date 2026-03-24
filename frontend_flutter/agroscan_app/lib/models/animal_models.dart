class Vacuna {

  final String tipo;
  final String dosis;

  Vacuna({
    required this.tipo,
    required this.dosis,
  });

  factory Vacuna.fromMap(
      Map<String, dynamic> map) {

    return Vacuna(
      tipo: map['tipo']?.toString() ?? '',
      dosis: map['dosis']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'dosis': dosis,
    };
  }
}



class RevisionMedica {

  final String observaciones;
  final String estadoSalud;

  RevisionMedica({
    required this.observaciones,
    required this.estadoSalud,
  });

  factory RevisionMedica.fromMap(
      Map<String, dynamic> map) {

    return RevisionMedica(

      observaciones:
          map['observaciones']?.toString() ?? '',

      estadoSalud:
          map['estado_salud']?.toString() ??
          map['estadoSalud']?.toString() ??
          '',

    );
  }

  Map<String, dynamic> toMap() {

    return {

      'observaciones': observaciones,
      'estado_salud': estadoSalud,

    };
  }
}



class Animal {

  final String codigoQR;
  final String raza;
  final double peso;
  final int edad;
  final String estadoSalud;

  int sincronizado;

  List<Vacuna> historialVacunas;
  List<RevisionMedica> historialClinico;



  Animal({

    required this.codigoQR,
    required this.raza,
    required this.peso,
    required this.edad,

    this.estadoSalud = "Excelente",

    this.sincronizado = 0,

    this.historialVacunas = const [],
    this.historialClinico = const [],
  });



  // ============================================
  // PARA SQLITE / API
  // ============================================

  Map<String, dynamic> toMap() {

    return {

      'codigoQR': codigoQR,
      'raza': raza,
      'peso': peso,
      'edad': edad,
      'estadoSalud': estadoSalud,
      'sincronizado': sincronizado,

    };
  }



  // ============================================
  // BLINDAJE TOTAL (Mongo / API / SQLite)
  // ============================================

  factory Animal.fromMap(
      Map<String, dynamic> map) {

    return Animal(

      /// ✅ ID seguro

      codigoQR:
          map['codigoQR']?.toString() ??
          map['codigo']?.toString() ??
          map['id']?.toString() ??
          map['_id']?.toString() ??
          'SIN_ID',


      /// ✅ texto seguro

      raza:
          map['raza']?.toString() ??
          'N/A',


      /// ✅ double seguro

      peso:
          double.tryParse(
              map['peso'].toString()
          ) ?? 0.0,


      /// ✅ int seguro

      edad:
          int.tryParse(
              map['edad'].toString()
          ) ?? 0,


      /// ✅ estado seguro

      estadoSalud:
          map['estadoSalud']?.toString() ??
          map['estado_salud']?.toString() ??
          'Bueno',


      /// ✅ sync seguro

      sincronizado:
          int.tryParse(
              map['sincronizado']
                  .toString()
          ) ?? 1,


      /// ✅ listas seguras

      historialVacunas:
          (map['historial_vacunas']
                  as List?)
              ?.map(
                (v) =>
                    Vacuna.fromMap(v),
              )
              .toList()
          ?? [],


      historialClinico:
          (map['historial_clinico']
                  as List?)
              ?.map(
                (v) =>
                    RevisionMedica
                        .fromMap(v),
              )
              .toList()
          ?? [],
    );
  }
}