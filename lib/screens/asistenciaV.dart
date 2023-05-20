import 'package:dam_u4_proyecto2_19400640/screens/asignacionE.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dam_u4_proyecto2_19400640/firebase_options.dart';
import 'package:dam_u4_proyecto2_19400640/utils/firebase_service.dart';
import 'package:intl/intl.dart';

class asistenciaV extends StatefulWidget {
  const asistenciaV({Key? key}) : super(key: key);

  @override
  State<asistenciaV> createState() => _asistenciaVState();
}

class _asistenciaVState extends State<asistenciaV> {
  String selectedOption = '';
  final docenteC = TextEditingController();
  final edificioC = TextEditingController();
  final fechaiC = TextEditingController();
  final fechafC = TextEditingController();
  final revisorC = TextEditingController();
  String docente = '';
  String edificio = '';
  DateTime fechai = DateTime.now();
  DateTime fechaf = DateTime.now();
  String revisor = '';
  void updateSelectedOption(String value) {
    setState(() {
      selectedOption = value ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Asistencias"),backgroundColor: Colors.purple,centerTitle: true,
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text('Ver todos los Registros'),
                value: 'opcion1',
              ),
              PopupMenuItem(
                child: Text('Buscar por docente'),
                value: 'opcion2',
              ),
              PopupMenuItem(
                child: Text('Buscar por edificio y fecha'),
                value: 'opcion3',
              ),
              PopupMenuItem(
                child: Text('Buscar fechas'),
                value: 'opcion4',
              ),
              PopupMenuItem(
                child: Text('Buscar por revisor'),
                value: 'opcion5',
              ),
            ];
          },
          onSelected: (value) {
            updateSelectedOption(value);
            print(value);
          },
        ),
      ],
      ),
      body: construirConsulta(selectedOption),
    );
  }
  Widget construirConsulta(String selectedOption){
    switch (selectedOption) {
      case 'opcion1':
        return FutureBuilder(
          future: getAsistencias(),
          builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data?.length, //se condiciona DATA porque puede ser que no retorne nada
              itemBuilder: (context, index){
                final asistencia = snapshot.data?[index];
                return Dismissible( // podemos desplazar los elementos a la derecha
                  onDismissed: (direction) async{
                    await deleteAsignacion(asistencia?['uid']);
                    snapshot.data?.removeAt(index);
                  },
                    confirmDismiss: (direction) async{
                      bool result = false;
                      result = await showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: Text("¿Deseas borrar la materia de: '${asistencia?['materia']}' ?"),
                          actions: [
                            TextButton(onPressed: (){
                              return Navigator.pop(context, false);
                            }, child: Text("Cancelar")),
                            TextButton(onPressed: (){
                              return Navigator.pop(context, true);
                            }, child: Text("Confirmar"))
                          ],
                        );
                      });
                      return result;
                    },
                    background: Container(
                      color: Colors.deepPurple,
                      child: const Icon(Icons.delete_forever, color: Colors.white,),
                    ),
                    direction: DismissDirection.startToEnd,
                    key: Key(asistencia?['uid']),
                    child: InkWell(
                    child: ListTile(
                      title: Text(asistencia?['docente']),
                      subtitle: Text("Edificio: ${asistencia?['edificio'] ?? ''}   \nFecha y hora:  ${asistencia?['fecha'].toString() ?? ''}\nRevisor: ${asistencia?['revisor'] ?? ''}"),
                      leading: CircleAvatar(
                        backgroundColor: Color.fromRGBO(242, 89, 22, 30),
                        child: Text(asistencia?['docente'].substring(0,1)),
                      ),
                    ),
                    )
                  );
                },
            );
                    }else{
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
          });
      case 'opcion2':
        return Column(
          children: [
            TextFormField(
              controller: docenteC,
              decoration: InputDecoration(
                labelText: "Ingresa el nombre del docente",
                prefixIcon: Icon(Icons.person_add_alt_1_outlined, color: Colors.blue),
                iconColor: Colors.blue,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  docente = docenteC.text;
                });
              },
              child: Text('Buscar'),
            ),
            SizedBox(
              height: 20, // Ajusta la altura según tus necesidades
            ),
            Expanded(
              child: FutureBuilder(
                future: getAsistenciasxD(docente),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    List<dynamic>? asistencias = snapshot.data as List<dynamic>?;
                    return ListView.builder(
                      itemCount: asistencias?.length ?? 0,
                      itemBuilder: (context, index) {
                        final asistencia = asistencias?[index];
                        return Dismissible(
                          onDismissed: (direction) async {
                            await deleteAsignacion(asistencia?['uid']);
                            asistencias?.removeAt(index);
                          },
                          confirmDismiss: (direction) async {
                            bool result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("¿Deseas borrar la materia de: '${asistencia?['materia']}' ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text("Confirmar"),
                                    ),
                                  ],
                                );
                              },
                            );
                            return result;
                          },
                          background: Container(
                            color: Colors.deepPurple,
                            child: const Icon(Icons.delete_forever, color: Colors.white,),
                          ),
                          direction: DismissDirection.startToEnd,
                          key: Key(asistencia?['uid'] ?? ''),
                          child: InkWell(
                            child: ListTile(
                              title: Text(asistencia?['docente'] ?? ''),
                              subtitle: Text("Edificio: ${asistencia?['edificio'] ?? ''}   \nFecha y hora:  ${asistencia?['fecha'].toString() ?? ''}\nRevisor: ${asistencia?['revisor'] ?? ''}"),
                              leading: CircleAvatar(
                                backgroundColor: Color.fromRGBO(242, 89, 22, 30),
                                child: Text(asistencia?['docente']?.substring(0,1) ?? ''),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(); // Retorna un contenedor vacío si no hay datos
                  }
                },
              ),
            ),
          ],
        );
    case 'opcion3':
      return Column(
        children: [
          TextFormField(
            controller: edificioC,
            decoration: InputDecoration(
              labelText: "Ingresa el nombre del edificio",
              prefixIcon: Icon(Icons.store, color: Colors.blue),
              iconColor: Colors.blue,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          TextField(
            controller: fechaiC,
            decoration: (InputDecoration(
              icon: Icon(Icons.calendar_today_rounded),
              labelText: "Fecha de inicio",
            )),
            onTap: () async{
              DateTime? fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
              if(fecha != null){
                setState(() {
                  fechaiC.text = DateFormat('dd-MM-yyyy').format(fecha);
                });
              }
            },
          ),
          TextField(
            controller: fechafC,
            decoration: (InputDecoration(
              icon: Icon(Icons.calendar_today_rounded),
              labelText: "Fecha de fin: ",
            )),
            onTap: () async{
              DateTime? fecha2 = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
              if(fecha2 != null){
                setState(() {
                  fechafC.text = DateFormat('dd-MM-yyyy').format(fecha2);
                });
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                edificio = edificioC.text;
                fechai = DateFormat('dd-MM-yyyy').parse(fechaiC.text);
                fechaf = DateFormat('dd-MM-yyyy').parse(fechafC.text);
              });
            },
            child: Text('Buscar'),
          ),
          SizedBox(
            height: 20, // Ajusta la altura según tus necesidades
          ),
          Expanded(
            child: FutureBuilder(
              future: getAsistenciasxFD(edificio, fechai,fechaf),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  List<dynamic>? asistencias = snapshot.data as List<dynamic>?;
                  return ListView.builder(
                    itemCount: asistencias?.length ?? 0,
                    itemBuilder: (context, index) {
                      final asistencia = asistencias?[index];
                      return Dismissible(
                        onDismissed: (direction) async {
                          await deleteAsignacion(asistencia?['uid']);
                          asistencias?.removeAt(index);
                        },
                        confirmDismiss: (direction) async {
                          bool result = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("¿Deseas borrar la materia de: '${asistencia?['materia']}' ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text("Confirmar"),
                                  ),
                                ],
                              );
                            },
                          );
                          return result;
                        },
                        background: Container(
                          color: Colors.deepPurple,
                          child: const Icon(Icons.delete_forever, color: Colors.white,),
                        ),
                        direction: DismissDirection.startToEnd,
                        key: Key(asistencia?['uid'] ?? ''),
                        child: InkWell(
                          child: ListTile(
                            title: Text(asistencia?['docente'] ?? ''),
                            subtitle: Text("Edificio: ${asistencia?['edificio'] ?? ''}   \nFecha y hora:  ${asistencia?['fecha'].toString() ?? ''}\nRevisor: ${asistencia?['revisor'] ?? ''}"),
                            leading: CircleAvatar(
                              backgroundColor: Color.fromRGBO(242, 89, 22, 30),
                              child: Text(asistencia?['docente']?.substring(0,1) ?? ''),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(); // Retorna un contenedor vacío si no hay datos
                }
              },
            ),
          ),
        ],
      );
      case 'opcion4':
        return Column(
          children: [
            TextField(
              controller: fechaiC,
              decoration: (InputDecoration(
                icon: Icon(Icons.calendar_today_rounded),
                labelText: "Fecha de inicio",
              )),
              onTap: () async{
                DateTime? fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
                if(fecha != null){
                  setState(() {
                    fechaiC.text = DateFormat('dd-MM-yyyy').format(fecha);
                  });
                }
              },
            ),
            TextField(
              controller: fechafC,
              decoration: (InputDecoration(
                icon: Icon(Icons.calendar_today_rounded),
                labelText: "Fecha de fin: ",
              )),
              onTap: () async{
                DateTime? fecha2 = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
                if(fecha2 != null){
                  setState(() {
                    fechafC.text = DateFormat('dd-MM-yyyy').format(fecha2);
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  fechai = DateFormat('dd-MM-yyyy').parse(fechaiC.text);
                  fechaf = DateFormat('dd-MM-yyyy').parse(fechafC.text);
                });
              },
              child: Text('Buscar'),
            ),
            SizedBox(
              height: 20, // Ajusta la altura según tus necesidades
            ),
            Expanded(
              child: FutureBuilder(
                future: getAsistenciasxF(fechai,fechaf),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    List<dynamic>? asistencias = snapshot.data as List<dynamic>?;
                    return ListView.builder(
                      itemCount: asistencias?.length ?? 0,
                      itemBuilder: (context, index) {
                        final asistencia = asistencias?[index];
                        return Dismissible(
                          onDismissed: (direction) async {
                            await deleteAsignacion(asistencia?['uid']);
                            asistencias?.removeAt(index);
                          },
                          confirmDismiss: (direction) async {
                            bool result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("¿Deseas borrar la materia de: '${asistencia?['materia']}' ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text("Confirmar"),
                                    ),
                                  ],
                                );
                              },
                            );
                            return result;
                          },
                          background: Container(
                            color: Colors.deepPurple,
                            child: const Icon(Icons.delete_forever, color: Colors.white,),
                          ),
                          direction: DismissDirection.startToEnd,
                          key: Key(asistencia?['uid'] ?? ''),
                          child: InkWell(
                            child: ListTile(
                              title: Text(asistencia?['docente'] ?? ''),
                              subtitle: Text("Edificio: ${asistencia?['edificio'] ?? ''}   \nFecha y hora:  ${asistencia?['fecha'].toString() ?? ''}\nRevisor: ${asistencia?['revisor'] ?? ''}"),
                              leading: CircleAvatar(
                                backgroundColor: Color.fromRGBO(242, 89, 22, 30),
                                child: Text(asistencia?['docente']?.substring(0,1) ?? ''),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(); // Retorna un contenedor vacío si no hay datos
                  }
                },
              ),
            ),
          ],
        );
      case 'opcion5':
        return Column(
          children: [
            TextFormField(
              controller: revisorC,
              decoration: InputDecoration(
                labelText: "Ingresa el nombre del revisor",
                prefixIcon: Icon(Icons.person_add_alt_1_outlined, color: Colors.blue),
                iconColor: Colors.blue,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  revisor = revisorC.text;
                });
              },
              child: Text('Buscar'),
            ),
            SizedBox(
              height: 20, // Ajusta la altura según tus necesidades
            ),
            Expanded(
              child: FutureBuilder(
                future: getAsistenciasxR(revisor),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    List<dynamic>? asistencias = snapshot.data as List<dynamic>?;
                    return ListView.builder(
                      itemCount: asistencias?.length ?? 0,
                      itemBuilder: (context, index) {
                        final asistencia = asistencias?[index];
                        return Dismissible(
                          onDismissed: (direction) async {
                            await deleteAsignacion(asistencia?['uid']);
                            asistencias?.removeAt(index);
                          },
                          confirmDismiss: (direction) async {
                            bool result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("¿Deseas borrar la materia de: '${asistencia?['materia']}' ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text("Confirmar"),
                                    ),
                                  ],
                                );
                              },
                            );
                            return result;
                          },
                          background: Container(
                            color: Colors.deepPurple,
                            child: const Icon(Icons.delete_forever, color: Colors.white,),
                          ),
                          direction: DismissDirection.startToEnd,
                          key: Key(asistencia?['uid'] ?? ''),
                          child: InkWell(
                            child: ListTile(
                              title: Text(asistencia?['docente'] ?? ''),
                              subtitle: Text("Edificio: ${asistencia?['edificio'] ?? ''}   \nFecha y hora:  ${asistencia?['fecha'].toString() ?? ''}\nRevisor: ${asistencia?['revisor'] ?? ''}"),
                              leading: CircleAvatar(
                                backgroundColor: Color.fromRGBO(242, 89, 22, 30),
                                child: Text(asistencia?['docente']?.substring(0,1) ?? ''),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(); // Retorna un contenedor vacío si no hay datos
                  }
                },
              ),
            ),
          ],
        );
      default:
        return const Center(
          child: Text('Seleccione una opción de filtro'),
        );
    }
  }
}
