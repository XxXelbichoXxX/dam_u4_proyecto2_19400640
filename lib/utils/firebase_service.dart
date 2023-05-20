import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

FirebaseFirestore db = FirebaseFirestore.instance;


//asignaciones
//get
Future<List> getAsignaciones() async {
  List asignaciones = [];
  CollectionReference collectionReferenceAsignaciones = db.collection('asignacion');
  QuerySnapshot queryAsignacion = await collectionReferenceAsignaciones.get();
    for(var doc in queryAsignacion.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final asignacion = {
        "uid" : doc.id,
        "docente": data['docente'],
        "edificio": data['edificio'],
        "salon": data['salon'],
        "horario": data['horario'],
        "materia": data['materia'],
      };
      asignaciones.add(asignacion);
    }
    await Future.delayed(const Duration(seconds: 1));

    return asignaciones;
  }


//add
Future<void> addAsignacion(String docente, String edificio, String salon, String horario, String materia) async{ //asincrono proque tenemos que esperar hasta que se guarde para terminar el proceso
  await db.collection("asignacion").add(
      {
        "docente": docente,
        "edificio": edificio,
        "salon": salon,
        "horario": horario,
        "materia": materia,
      }); //son llaves porque es un json
}

//update
Future<void> updateAsignacion(String uid ,String docente, String edificio, String salon, String horario, String materia) async{
  await db.collection('asignacion').doc(uid).set(
      {
        "docente": docente,
        "edificio": edificio,
        "salon": salon,
        "horario": horario,
        "materia": materia,
      });
}

//delete
Future<void> deleteAsignacion(String docente) async{
  await db.collection('asignacion').doc(docente).delete();
}


//asistencias
Future<List> getAsistencias() async {
  tz.initializeTimeZones();
  List asistencias = [];
  CollectionReference collectionReferenceAsistencias = db.collection('asistencia');
  QuerySnapshot queryAsistencia = await collectionReferenceAsistencias.get();
  final location = tz.getLocation('America/Mazatlan');
  for(var doc in queryAsistencia.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final asistencia = {
      "uid": doc.id,
      "docente": data['docente'],
      "edificio": data['edificio'],
      "fecha": DateFormat('dd-MM-yyyy HH:mm:ss').format(tz.TZDateTime.from(data['fecha'].toDate(), location)),
      "revisor": data['revisor'],
    };
    asistencias.add(asistencia);
  }
  await Future.delayed(const Duration(seconds: 1));

  return asistencias;
}

Future<List> getAsistenciasxD(String campo) async {
  tz.initializeTimeZones();
  List asistencias = [];
  CollectionReference collectionReferenceAsistencias = db.collection('asistencia');
  QuerySnapshot queryAsistencia = await collectionReferenceAsistencias.where('docente',isEqualTo: campo).get();
  final location = tz.getLocation('America/Mazatlan');
  for(var doc in queryAsistencia.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final asistencia = {
      "docente": data['docente'],
      "edificio": data['edificio'],
      "fecha": DateFormat('dd-MM-yyyy HH:mm:ss').format(tz.TZDateTime.from(data['fecha'].toDate(), location)),
      "revisor": data['revisor'],
    };
    asistencias.add(asistencia);
  }
  await Future.delayed(const Duration(seconds: 1));

  return asistencias;
}

Future<List> getAsistenciasxF(DateTime fechaInicial, DateTime fechaFinal) async {
  tz.initializeTimeZones();
  List asistencias = [];
  CollectionReference collectionReferenceAsistencias = db.collection('asistencia');
  QuerySnapshot queryAsistencia = await collectionReferenceAsistencias
      .where('fecha',isGreaterThanOrEqualTo: fechaInicial)
      .where('fecha',isLessThanOrEqualTo: fechaFinal)
      .get();
    final location = tz.getLocation('America/Mazatlan');
    for(var doc in queryAsistencia.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final asistencia = {
      "docente": data['docente'],
      "edificio": data['edificio'],
      "fecha": DateFormat('dd-MM-yyyy HH:mm:ss').format(tz.TZDateTime.from(data['fecha'].toDate(), location)),
      "revisor": data['revisor'],
    };
    asistencias.add(asistencia);
  }
  await Future.delayed(const Duration(seconds: 1));

  return asistencias;
}

Future<List> getAsistenciasxFD(String edificio, DateTime fechaInicial, DateTime fechaFinal) async {
  tz.initializeTimeZones();
  List asistencias = [];
  CollectionReference collectionReferenceAsistencias = db.collection('asistencia');
  QuerySnapshot queryAsistencia = await collectionReferenceAsistencias
      .where('fecha',isGreaterThanOrEqualTo: fechaInicial)
      .where('fecha',isLessThanOrEqualTo: fechaFinal)
      .where('edificio',isEqualTo: edificio)
      .get();
  final location = tz.getLocation('America/Mazatlan');
  for(var doc in queryAsistencia.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final asistencia = {
      "docente": data['docente'],
      "edificio": data['edificio'],
      "fecha": DateFormat('dd-MM-yyyy HH:mm:ss').format(tz.TZDateTime.from(data['fecha'].toDate(), location)),
      "revisor": data['revisor'],
    };
    asistencias.add(asistencia);
  }
  await Future.delayed(const Duration(seconds: 1));

  return asistencias;
}

Future<List> getAsistenciasxR(String campo) async {
  tz.initializeTimeZones();
  List asistencias = [];
  final location = tz.getLocation('America/Mazatlan');
  CollectionReference collectionReferenceAsistencias = db.collection('asistencia');
  QuerySnapshot queryAsistencia = await collectionReferenceAsistencias.where('revisor',isEqualTo: campo).get();
  for(var doc in queryAsistencia.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final asistencia = {
      "docente": data['docente'],
      "edificio": data['edificio'],
      "fecha": DateFormat('dd-MM-yyyy HH:mm:ss').format(tz.TZDateTime.from(data['fecha'].toDate(), location)),
      "revisor": data['revisor'],
    };
    asistencias.add(asistencia);
  }
  await Future.delayed(const Duration(seconds: 1));

  return asistencias;
}




//add
Future<void> addAsistencia(String docente, String edificio, DateTime fecha, String revisor) async{ //asincrono proque tenemos que esperar hasta que se guarde para terminar el proceso
  await db.collection("asistencia").add(
      {
        "docente": docente,
        "edificio": edificio,
        "fecha": fecha,
        "revisor": revisor,
      }); //son llaves porque es un json
}







