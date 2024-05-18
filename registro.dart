import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'usuarioVista.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {

  //instancia de firebase database
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>();

  //region Controladores de texto
  final _usuarioDriver = TextEditingController();
  final _correoDriver = TextEditingController();
  final _telefonoDriver = TextEditingController();
  final _passwordDriver = TextEditingController();
  final _passwordDriver2 = TextEditingController();
  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuarios'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => const UsuarioVista()
                    ));
              },
              icon: const Icon(Icons.list))
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(50),
          children: [
            const Center(
            child: Text('Registra tus datos',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightBlue),
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Campo obligatorio';
                }
                return null;
              },
              controller: _usuarioDriver,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario:',
                icon: Icon(Icons.person)
              ),
            ),
            TextFormField(
              validator: (value){
                var regexCorreo = RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                if (value!.isEmpty) {
                  return 'Campo obligatorio';
                }
                if(!(regexCorreo.hasMatch(value))){
                  return 'Debe seguir el ejemplo usuario@serv.com';
                }
                return null;
              },
              controller: _correoDriver,
              decoration: const InputDecoration(
                labelText: 'Correo:',
                icon: Icon(Icons.email),
              ),
            ),
            TextFormField(
              validator: (value){
                var regexTelefono = RegExp(r'^[0-9]{10}');
                if(value!.isNotEmpty && !(regexTelefono.hasMatch(value))){
                  return 'Debe ser de 10 digitos';
                }
                return null;
              },
              controller: _telefonoDriver,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: 'Teléfono:',
                  icon: Icon(Icons.phone),
              ),
            ),
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Campo obligatorio';
                }
                return null;
              },
              controller: _passwordDriver,
              decoration: const InputDecoration(
                  labelText: 'Contraseña:',
                  icon: Icon(Icons.password)
              ),
            ),
            TextFormField(
              validator: (value){
                if(_passwordDriver.text != value!){
                  return 'Los campos no coinciden';
                }
                return null;
              },
              controller: _passwordDriver2,
              decoration: const InputDecoration(
                  labelText: 'Contraseña:',
                  icon: Icon(Icons.password)
              ),
            ),
            const SizedBox(height: 20,),
            Center(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                      if (_formKey.currentState!.validate()) {//valida los campos del formulario
                        //mapeo de los datos
                        Map<String, dynamic> data = {
                          "usuario": _usuarioDriver.text,
                          "correo": _correoDriver.text,
                          "telefono": _telefonoDriver.text,
                          "contraseña": _passwordDriver.text,
                        };
                        insertarFB("Usuarios", data);//inserción a bd
                        limpiarCampos();
                      }
                  },
                  child: const Text('Registrar',
                    style: TextStyle(fontSize: 16),
                  ),
                )
            ),
          ]),
      ),
    );
  }

  //region métodos mensaje, seleccionarFecha e insertarFB
  void mensaje (String s, Color fondo, Color texto) {
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
         content: Text(s,
           style: TextStyle(
             color: texto
           ),),
         backgroundColor: fondo,
         behavior: SnackBarBehavior.floating,
     )
    );
  }

  Future<void> insertarFB(String s, Map<String, dynamic> data) async {
    //insertamos los datos en la instancia de referencia
    await ref.child(s).push().set(data).then((value) {
      mensaje ("Operación exitosa", Colors.green, Colors.white);

    }).onError((error, stackTrace) {
      mensaje("Error inesperado, vuelve intentarlo más tarde", Colors.red, Colors.white);
    });
  }

  void limpiarCampos() {
    _usuarioDriver.clear();
    _correoDriver.clear();
    _telefonoDriver.clear();
    _passwordDriver.clear();
    _passwordDriver2.clear();
  }
//endregion
}