import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ERCaller'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Controladores de contenido
  int _indice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E.R. Caller",
          style: TextStyle(
            color: Colors.black
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: dinamico(),
      floatingActionButton: FloatingActionButton.large(
        onPressed: (){},
        child: Icon(Icons.phone),
        backgroundColor: Colors.amber,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Icon(Icons.person, size: 40,),
                      radius: 40,
                      foregroundColor: Colors.amber,
                    ),
                    Text("Control"),
                    Text("(c) Moviles 2024",
                      style: TextStyle(
                          fontSize: 14,
                      ),
                    )
                  ],
                ),
              decoration: BoxDecoration(
                color: Colors.amber
              ),
            ),
            SizedBox(height: 35,),
            itemDrawer(1, Icons.access_alarm, "Cosa 1"),
            itemDrawer(2, Icons.access_alarm, "Cosa 2"),
            itemDrawer(3, Icons.access_alarm, "Cosa 3"),
            itemDrawer(4, Icons.access_alarm, "Cosa 4"),
          ],
        ),
      ),
    );
  }

  Widget itemDrawer(int indice, IconData icon, String text){
    return ListTile(
      onTap: (){
        setState(() {
          _indice = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [
          Expanded(child: Icon(icon)),
          Expanded(child: Text(text), flex: 2,)
        ],
      ),
    );
  }

  Widget dinamico(){
    switch(_indice){
      case 1: return Center(child: Text("Cosa 1"),);
      case 2: return Center(child: Text("Cosa 2"),);
      case 3: return Center(child: Text("Cosa 3"),);
      case 4: return Center(child: Text("Cosa 4"),);
      default: return Center(child: Text("NO debrias poder ver esto"),);
    }
  }
}
