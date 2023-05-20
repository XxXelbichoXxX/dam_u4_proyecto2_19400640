import 'package:dam_u4_proyecto2_19400640/utils/firebase_service.dart';
import 'package:flutter/material.dart';

class asignacionE extends StatefulWidget {
  final Map<String, dynamic>? asignacion;
  const asignacionE({Key? key, required this.asignacion}) : super(key: key);

  @override
  State<asignacionE> createState() => _asignacionEState();
}

class _asignacionEState extends State<asignacionE> {
  final formKey = GlobalKey<FormState>();
  String uid = "";
  final docentecontroller = TextEditingController();
  final edificiocontroller = TextEditingController();
  final saloncontroller = TextEditingController();
  final horariocontroller = TextEditingController();
  final materiacontroller = TextEditingController();


  @override
  void initState(){
    super.initState();
    uid = widget.asignacion?['uid'] ?? '';
    docentecontroller.text = widget.asignacion?['docente'] ?? '';
    edificiocontroller.text = widget.asignacion?['edificio'] ?? '';
    saloncontroller.text = widget.asignacion?['salon'] ?? '';
    horariocontroller.text = widget.asignacion?['horario'] ?? '';
    materiacontroller.text = widget.asignacion?['materia'] ?? '';

  }

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
              Text("Actualiza una", style: TextStyle(fontSize: 30, color:Color(0xFF363f93)),),
              Text("Asignación de docente", style: TextStyle(fontSize: 30, color:Color(0xFF363f93)),),
              SizedBox(height: 25.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Ingresa el docente",
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
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
              TextFormField(
                controller: saloncontroller,
                decoration: InputDecoration(
                  labelText: "Ingresa el salon",
                  prefixIcon: Icon(Icons.room, color: Colors.blue),
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
              SizedBox(height: 7.0,),
              TextFormField(
                controller: horariocontroller,
                decoration: InputDecoration(
                  labelText: "Ingresa el horario",
                  prefixIcon: Icon(Icons.access_time, color: Colors.blue),
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
                validator: (value) {
                  if (value!.isEmpty || !RegExp(r'^\d{1,2}\s(?:am|pm)$').hasMatch(value!)) {
                    return "Ingresa un horario válido de materia";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 7.0,),
              TextFormField(
                controller: materiacontroller,
                decoration: InputDecoration(
                  labelText: "Ingresa la materia",
                  prefixIcon: Icon(Icons.book_outlined, color: Colors.blue),
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
                validator: (value) {
                  if (value!.isEmpty || !RegExp(r'^[a-zA-Z]').hasMatch(value!)) {
                    return "Ingresa un nombre válido de materia";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Actualizar asignación", style: TextStyle(fontSize: 22, color: Color(0xFF363f93)),),
                  FloatingActionButton(
                    onPressed: () async{
                      if (formKey.currentState!.validate()) {
                        final snackBar = SnackBar(content: Text("Se actualizo correctamente"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        await updateAsignacion(uid, docentecontroller.text, edificiocontroller.text, saloncontroller.text, horariocontroller.text, materiacontroller.text).then((value) => {Navigator.pop(context)});
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

