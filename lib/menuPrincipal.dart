import 'package:dam_u4_proyecto2_19400640/screens/asignacionA.dart';
import 'package:dam_u4_proyecto2_19400640/screens/asignacionesV.dart';
import 'package:dam_u4_proyecto2_19400640/screens/asistenciaA.dart';
import 'package:dam_u4_proyecto2_19400640/screens/asistenciaV.dart';
import 'package:flutter/material.dart';

class menu extends StatefulWidget {
  const menu({Key? key}) : super(key: key);

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Control de asistencias", textAlign: TextAlign.center,),
      backgroundColor: Color.fromRGBO(242, 89, 22, 30), centerTitle: true,),
      backgroundColor: Color.fromRGBO(4, 119, 191, 1),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            Card(
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (builder) => asignacionA()));
              },
              splashColor: Colors.blueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.person_pin_outlined, size: 70.0, color: Color.fromRGBO(242, 110, 34, 1)),
                    Center(
                      child: Text(
                        "Asignación de materia",
                        style: TextStyle(fontSize: 17.0),
                        textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (builder) => asistenciaA()));
                },
                splashColor: Colors.blueAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.pending_actions, size: 70.0, color: Color.fromRGBO(242, 110, 34, 1)),
                      Center(
                        child: Text(
                          "Captura asistencia",
                          style: TextStyle(fontSize: 17.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (builder) => asignacionesV()));
                },
                splashColor: Colors.blueAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.person_off_rounded, size: 70.0, color: Color.fromRGBO(242, 110, 34, 1)),
                      Center(
                        child: Text(
                          "Visualiza asignaciones de materias",
                          style: TextStyle(fontSize: 17.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (builder) => asistenciaV()));
                },
                splashColor: Colors.blueAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.bookmark_added_rounded, size: 70.0, color: Color.fromRGBO(242, 110, 34, 1)),
                      Center(
                        child: Text(
                          "Visualiza asistencias",
                          style: TextStyle(fontSize: 17.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

