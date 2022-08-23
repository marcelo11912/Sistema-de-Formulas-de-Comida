
import 'package:flutter/material.dart';
import 'package:untitled/db/acciones.dart';
import 'package:untitled/ingredientes.dart';
import 'package:untitled/model/Receta.dart';


class Recetas extends StatefulWidget {
  const Recetas ({Key key}) : super(key: key);

  @override
  State<Recetas> createState() => _RecetasState();
}

class _RecetasState extends State<Recetas> {
  final _formKey = GlobalKey<FormState>();
  DataBase db = DataBase();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Recetas'),),
        body: Container(
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
            ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialogWithFields();
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.add),
        )
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
    return Dismissible(
      secondaryBackground: Container(
        child: const Center(
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: Colors.red,
      ),
      background: Container(),
      key: UniqueKey(),
      onDismissed: (DismissDirection direction) async {
        await db.deleteRecetas(receta, receta.id);

      },
      child: ListTile(
          title: Text(receta.name),
          trailing: Icon(Icons.chevron_right_outlined),
          onTap: ()  {
             Navigator.push(context,
                 MaterialPageRoute(builder: (context) =>  Ingrediente(receta.name, receta.id)));
          }),
    );
  }

  void showDialogWithFields() {
    showDialog(
      context: context,
      builder: (_) {
        var recetaController = TextEditingController();
        return AlertDialog(
          title: Text('Receta'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: recetaController,
                  decoration: InputDecoration(hintText: 'Nombre de receta'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Receta receta = Receta(recetaController.text) ;
                db.insertReceta(receta);
                Navigator.pop(context);
                setState(() {
                  FutureBuilder<List>(
                      future: db.recetas(),
                      initialData: [],
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? _recetasListViewBuilder(context, snapshot)
                            : _waiting();
                      });
                });
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
  Widget _waiting() {
    return const Center(
      child: Text("No existen recetas"),
    );
  }

}
