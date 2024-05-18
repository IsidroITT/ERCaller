import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'modelos/usuario.dart';

class Listado extends StatefulWidget {
  const Listado({super.key});

  @override
  State<Listado> createState() => _ListadoState();
}

class _ListadoState extends State<Listado> {

  //instancia de referencia de firebase database
  DatabaseReference rtdb = FirebaseDatabase.instance.ref();

  //lista del modelo de datos a recuperar
  List<Usuario> listaUsuarios = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de usuarios'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: listaUsuarios.length,
          itemBuilder: (context, index){
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.accessibility),
              ),
              title: Text('${listaUsuarios[index].usuarioDatos!.usuario!} - ${listaUsuarios[index].usuarioDatos!.telefono!}'),
              subtitle: Text(listaUsuarios[index].usuarioDatos!.correo!),
              trailing: IconButton(
                  onPressed: (){
                    confirmar('¿Desea eliminar a ${listaUsuarios[index].key}?', Colors.red, index);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,)),
            );
          }),
    );
  }

  void cargarLista() {
    rtdb.child("Usuarios").onChildAdded.listen((data) {
      UsuarioDatos usuarioDatos = UsuarioDatos.fromJSON(data.snapshot.value as Map);
      Usuario usuario = Usuario(
          key: data.snapshot.key,
          usuarioDatos: usuarioDatos
      );
      listaUsuarios.add(usuario);
      setState(() {});
    });
  }

  void confirmar(String s, Color c, int i) {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            icon: const Icon(Icons.warning),
            title: const Text('Advertencia'),
            content: Text(s),
            backgroundColor: c,
            actions: [
              TextButton(
                  onPressed: (){
                    rtdb.child("Usuarios").child(listaUsuarios[i].key!).remove().then((value){
                      listaUsuarios.remove(i);
                      setState(() {});
                    });
                    Navigator.pop(context);
                    refrescar();
                  },
                  child: const Text('Sí')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text('No')
              ),
            ],
          );
        });
  }

  void refrescar() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Listado()));
  }
}
