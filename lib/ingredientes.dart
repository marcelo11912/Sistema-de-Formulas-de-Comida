

import 'package:flutter/material.dart';
import 'package:untitled/Ingrediente.dart';
import 'package:untitled/model/Ingrediente.dart';
import 'package:untitled/recetasEdit.dart';

import 'db/acciones.dart';

class Ingrediente extends StatefulWidget {
  final String nombre;
  final int id;
  const Ingrediente(this.nombre, this.id,{Key key}) : super(key: key);

  @override
  State<Ingrediente> createState() => _IngredienteState();
}

class _IngredienteState extends State<Ingrediente> {
  DataBase db = DataBase();
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.nombre),

          actions: <Widget>[
            TextButton(
              style: style,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  RecetaEdit(widget.nombre,widget.id)));
              },
              child: const Icon(Icons.edit_sharp),
            ),

          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
            child: Column(children: <Widget>[
              Expanded(
                child: FutureBuilder<List>(
                    future: db.ingredientes(widget.id),
                    initialData: [],
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? _recetasListViewBuilder(context, snapshot)
                          : _waiting();
                    }),
              ),
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  Ingredientes(widget.nombre,widget.id,0,"","",false)));
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

  Widget _recetaTile(IngredienteModel ingrediente) {
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
        await db.deleteIngrediente(ingrediente, ingrediente.id);
      },
      child: ListTile(
          title: Text(ingrediente.name),
          subtitle: Text(ingrediente.valor.toString()),
          trailing: Icon(Icons.chevron_right_outlined),
          onTap: ()  {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  Ingredientes(widget.nombre,widget.id,ingrediente.id,ingrediente.name,ingrediente.valor.toString(),true)));
          }),
    );
  }
  Widget _waiting() {
    return const Center(
      child: Text("No existen ingredientes"),
    );
  }
  Future<void>_refresh(){
    setState(() {

    });
    return Future.delayed(Duration(milliseconds: 50));
  }

}
