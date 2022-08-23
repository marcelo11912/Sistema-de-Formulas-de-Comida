import 'package:flutter/material.dart';
import 'package:untitled/preparacion.dart';
import 'package:untitled/recetas.dart';

import 'db/acciones.dart';
import 'model/Receta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key,  this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataBase db = DataBase();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chimek Yoon'),
      ),
      body:  RefreshIndicator(
        onRefresh: _refresh,
          child: Column(children: <Widget>[
            Expanded(
              child: FutureBuilder<List>(
                  future: db.recetas(),
                  initialData: [],
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? _recetasListViewBuilder(context, snapshot)
                        : _waiting();
                  }),
            ),
          ])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text(
                'Chimek Yoon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Recetas'),
              leading: const Icon(Icons.receipt),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => const Recetas()));
              },

            ),
          ],
        ),
      ),
    );
  }
  Widget _recetasListViewBuilder(context, snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: snapshot.data.length,
      itemBuilder: (context, i) {
        return _recetaTile(snapshot.data[i]);
      },
    );
  }

  Widget _recetaTile(Receta receta) {
    return Container(
      child: ListTile(
          title: Text(receta.name),
          onTap: ()  {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  Prepracion(receta.name,receta.id)));
          }));

  }
  Widget _waiting() {
    return Container(
      child: ListView(

      )
    );
    return const Center(
      child: Text("No existen recetas"),
    );
  }
  Future<void>_refresh(){
    setState(() {
    });
    return Future.delayed(Duration(milliseconds: 50));
  }
}
