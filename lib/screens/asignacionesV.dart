import 'package:dam_u4_proyecto2_19400640/screens/asignacionE.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dam_u4_proyecto2_19400640/firebase_options.dart';
import 'package:dam_u4_proyecto2_19400640/utils/firebase_service.dart';

class asignacionesV extends StatefulWidget {
  const asignacionesV({Key? key}) : super(key: key);

  @override
  State<asignacionesV> createState() => _asignacionesVState();
}

class _asignacionesVState extends State<asignacionesV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Asignaciones"),backgroundColor: Colors.purple,centerTitle: true,),
        body: FutureBuilder( //utilizamos futurebuilder para construir algo hasta que retorne la información
            future: getAsignaciones(),
            builder: (context, snapshot){ //snapshot es el resultado de la promesa
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data?.length, //se condiciona DATA porque puede ser que no retorne nada
                  itemBuilder: (context, index){
                    final asignacion = snapshot.data?[index];
                    return Dismissible( // podemos desplazar los elementos a la derecha
                      onDismissed: (direction) async{
                        await deleteAsignacion(asignacion?['uid']);
                        snapshot.data?.removeAt(index);
                      },
                      confirmDismiss: (direction) async{
                        bool result = false;
                        result = await showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("¿Deseas borrar la materia de: '${asignacion?['materia']}' ?"),
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
                      key: Key(asignacion?['uid']),
                      child: InkWell(
                        onTap: (){

                        },
                        child: ListTile(
                          title: Text(asignacion?['docente']),
                          subtitle: Text("Edificio: ${asignacion?['edificio'] ?? ''}   Salon:  ${asignacion?['salon'] ?? ''}\nMateria: ${asignacion?['materia'] ?? ''}   Horario:  ${asignacion?['horario'] ?? ''}"),
                          leading: CircleAvatar(
                            backgroundColor: Color.fromRGBO(242, 89, 22, 30),
                            child: Text(asignacion?['docente'].substring(0,1)),
                          ),
                        ),
                        onLongPress: () async{
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => asignacionE(asignacion: asignacion),),);
                          setState(() {
                          });
                        },
                      )
                    );
                  },
                );

              }else{
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
    );
  }
}
