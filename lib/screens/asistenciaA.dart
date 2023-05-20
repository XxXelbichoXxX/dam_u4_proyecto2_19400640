import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u4_proyecto2_19400640/utils/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class asistenciaA extends StatefulWidget {
  const asistenciaA({Key? key}) : super(key: key);

  @override
  State<asistenciaA> createState() => _asistenciaAState();
}

class _asistenciaAState extends State<asistenciaA> {
  final formKey = GlobalKey<FormState>();
  final docentecontroller = TextEditingController();
  final edificiocontroller = TextEditingController();
  final fechacontroller = TextEditingController();
  final revisorcontroller = TextEditingController();

  String name="";

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFffffff),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Form(
          key: formKey, //key for form
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.0),
                Text("Ingresa una nueva", style: TextStyle(fontSize: 30, color:Color(0xFF363f93)),),
                Text("Asistencia", style: TextStyle(fontSize: 30, color:Color(0xFF363f93)),),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Ingresa el docente",
                    prefixIcon: Icon(Icons.person, color: Color.fromRGBO(242, 89, 22, 30)),
                    iconColor: Color.fromRGBO(242, 89, 22, 30),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(242, 89, 22, 30), width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'^[a-zA-Z]').hasMatch(value!)) {
                      return "Ingresa un nombre válido de docente";
                    } else {
                      return null;
                    }
                  },
                  controller: docentecontroller,
                ),
                SizedBox(height: 7.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Ingresa el edificio",
                    prefixIcon: Icon(Icons.store, color: Color.fromRGBO(242, 89, 22, 30)),
                    iconColor: Colors.blue,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(242, 89, 22, 30), width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'^[a-zA-Z]').hasMatch(value!)) {
                      return "Ingresa un nombre válido de edificio";
                    } else {
                      return null;
                    }
                  },
                  controller: edificiocontroller,
                ),
                SizedBox(height: 7.0,),
                TextField(
                  controller: fechacontroller,
                  decoration: (InputDecoration(
                    icon: Icon(Icons.calendar_today_rounded, color: Color.fromRGBO(242, 89, 22, 30),),
                    labelText: "Fecha de la asistencia: ",
                  )),
                  onTap: () async{
                    DateTime? fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
                    if(fecha != null){
                      setState(() {
                        fechacontroller.text = DateFormat('yyyy-MM-dd').format(fecha);
                      });
                    }
                  },
                ),
                SizedBox(height: 7.0,),
                TextFormField(
                  controller: revisorcontroller,
                  decoration: InputDecoration(
                    labelText: "Ingresa el revisor",
                    prefixIcon: Icon(Icons.access_time, color: Color.fromRGBO(242, 89, 22, 30)),
                    iconColor: Colors.blue,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(242, 89, 22, 30), width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'^[a-zA-Z]').hasMatch(value!)) {
                      return "Ingresa un nombre válido de revisor";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Registrar asistencia", style: TextStyle(fontSize: 22, color: Color(0xFF363f93)),),
                    FloatingActionButton(
                      onPressed: () async{
                        if (formKey.currentState!.validate()) {
                          final snackBar = SnackBar(content: Text("Alta"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          await addAsistencia(docentecontroller.text, edificiocontroller.text, DateTime.parse(fechacontroller.text), revisorcontroller.text).then((value) => {Navigator.pop(context)});
                        }
                      },
                      child: Icon(Icons.arrow_forward),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      shape: CircleBorder(),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

