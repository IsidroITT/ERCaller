import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UsuarioVista extends StatefulWidget {
  const UsuarioVista({super.key});

  @override
  State<UsuarioVista> createState() => _UsuarioVistaState();
}

List tiposSangre = ['A+', 'A-', 'B+', 'B-', 'AB+','AB-','O+', 'O-'];
List padecimientos = ['Ninguna','Diabetes', 'VIH', 'Hipertensión', 'Cáncer'];

class _UsuarioVistaState extends State<UsuarioVista> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('usuario'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: pantalla(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.emergency),
              label: 'Emergencia'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_information),
              label: 'Hist. Clínico'
          ),
        ],
        currentIndex: _indice,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.lime,
        type: BottomNavigationBarType.fixed,
        onTap: (indice){
          setState(() {
            _indice = indice;
          });
        },
      ),
    );
  }

  Widget pantalla() {
    switch(_indice){
      case 0: return _radioPTSD();
      case 1: return _historialMed();
      default: return const CircleAvatar(child: Icon(Icons.person),);
    }
  }

  Future<Position> determinarPosicion () async {
     LocationPermission permiso = await Geolocator.checkPermission();
     if(permiso == LocationPermission.denied){
        permiso = await Geolocator.requestPermission();
        if(permiso == LocationPermission.denied){
          return Future.error('No cuenta con los permisos necesarios');
        }
     }
     return await Geolocator.getCurrentPosition();
  }

  void devolverPosiscionActual () async {
    Position posicion = await determinarPosicion();
    mensaje("${posicion.altitude}.${posicion.latitude}.${posicion.longitude}", Colors.white, Colors.black);
  }

  Widget _radioPTSD() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Text('Pulsa el botón en caso de emergencia',
            style: TextStyle(
              fontSize: 18,
              color: Colors.lightBlue,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                elevation: MaterialStatePropertyAll(2.0),
                shape: MaterialStatePropertyAll(CircleBorder()),
                shadowColor: MaterialStatePropertyAll(Colors.black),
                fixedSize: MaterialStatePropertyAll(Size(180, 90))
              ),
              child: const Icon(
                  Icons.emergency_share,
                  size: 60,
                  color: Colors.red,
                  semanticLabel: 'Pulsa en caso de emergencia',
              ),
              onPressed: (){
                devolverPosiscionActual();
              }
          ),
        ),
      ],
    );
  }

  //region variable para formulario
  final _formKey = GlobalKey<FormState>();

  final _nombreDriver = TextEditingController();
  final _apellidoDriver = TextEditingController();
  final _fechaDriver = TextEditingController();
  final _estaturaDriver = TextEditingController();
  final _pesoDriver = TextEditingController();
  final _famNombreDriver = TextEditingController();
  final _famApellidoDriver = TextEditingController();
  final _famTelefonoDriver = TextEditingController();

  String tipoSeleccionado = tiposSangre.first;
  String padecimientoSeleccionado = padecimientos.first;
  //endregion

  Widget _historialMed() {
    return Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Center(
              child: Text('Historial Clínico',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.lightBlue),
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Campo requerido';
                }
                return null;
              },
              controller: _nombreDriver,
              decoration: const InputDecoration(
                labelText: 'Nombre:',
              ),
            ),
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Campo requerido';
                }
                return null;
              },
              controller: _apellidoDriver,
              decoration: const InputDecoration(
                labelText: 'Apellido:',
              ),
            ),
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Campo requerido';
                }
                return null;
              },
              controller: _fechaDriver,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha de Nacimiento:',
                icon: Icon(Icons.date_range)
              ),
              onTap: (){
                seleccionarFecha();
              },
            ),
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Campo requerido';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              controller: _estaturaDriver,
              decoration: const InputDecoration(
                labelText: 'Estatura:',
                suffixText: 'cm',
              ),
            ),
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Campo requerido';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              controller: _pesoDriver,
              decoration: const InputDecoration(
                labelText: 'Peso:',
                suffixText: 'Kg',
              ),
            ),
            DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Tipo de sangre:',
                  icon: Icon(Icons.bloodtype)
                ),
                value: tipoSeleccionado,
                items: tiposSangre.map((e) {
                  return DropdownMenuItem(
                      value: e,
                      child: Text(e));
                }).toList(),
                onChanged: (valor){
                  setState(() {
                    tipoSeleccionado = valor!.toString();
                  });
                }
            ),
            DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Enfermedad cronica:',
                  icon: Icon(Icons.sick)
                ),
                value: padecimientoSeleccionado,
                items: padecimientos.map((e) {
                  return DropdownMenuItem(
                      value: e,
                      child: Text(e));
                }).toList(),
                onChanged: (valor){
                  setState(() {
                    padecimientoSeleccionado = valor!.toString();
                  });
                }
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text('Familiar ó persona de confianza',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.lightBlue),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _famNombreDriver,
              decoration: const InputDecoration(
                labelText: 'Nombre:',
              ),
            ),
            TextFormField(
              controller: _famApellidoDriver,
              decoration: const InputDecoration(
                labelText: 'Apellido:',
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
              controller: _famTelefonoDriver,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono:',
                icon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                      foregroundColor: MaterialStatePropertyAll<Color>(Colors.white)
                    ),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){

                      }
                    },
                    child: const Text('Registrar',
                      style: TextStyle(fontSize: 16),
                    )
                ),
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
                        foregroundColor: MaterialStatePropertyAll<Color>(Colors.white)
                    ),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (builder){
                            return AlertDialog(
                              title: const Text('Peligro'),
                              content: const Text('¿Desea eleiminar este registro?'),
                              backgroundColor: Colors.red,
                              icon: const Icon(Icons.warning),
                              actions: [
                                TextButton(
                                    onPressed: (){
                                      limpiarCampos();
                                      Navigator.pop(context);
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
                          }
                      );
                    },
                    child: const Text('Eliminar',
                      style: TextStyle(fontSize: 16),
                    )
                ),
              ],
            ),
          ],
        )
    );
  }

  //region métodos genericos
  Future<void> seleccionarFecha() async {
    DateTime? fechaSelecionada = await showDatePicker(
      context: context,
      firstDate: DateTime(1910),
      initialDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (fechaSelecionada != null){
      setState(() {
        _fechaDriver.text = fechaSelecionada.toString().split(" ")[0];
      });
    }
  }

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

  void limpiarCampos(){
     _nombreDriver.clear();
     _apellidoDriver.clear();
     _fechaDriver.clear();
     _estaturaDriver.clear();
     _pesoDriver.clear();
     _famNombreDriver.clear();
     _famApellidoDriver.clear();
     _famTelefonoDriver.clear();
  }
//endregion
}