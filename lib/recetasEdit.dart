import 'package:flutter/material.dart';
import 'package:untitled/model/Receta.dart';
import 'package:untitled/recetas.dart';

import 'db/acciones.dart';

class RecetaEdit extends StatefulWidget {
  final String nombre;
  final int id;
  const RecetaEdit(this.nombre, this.id,{Key key}) : super(key: key);

  @override
  State<RecetaEdit> createState() => _RecetaEditState();
}

class _RecetaEditState extends State<RecetaEdit> {
  DataBase db = DataBase();
  @override
  Widget build(BuildContext context) {
    var recetaController = TextEditingController(text: widget.nombre);
    final ButtonStyle style =
    TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Editar Receta"),
          actions: <Widget>[
            TextButton(
              style: style,
              onPressed: () {
                Receta receta = new Receta.edit(widget.id, recetaController.text);
                db.updateReceta(receta);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  Recetas()));

              },
              child: const Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Nombre de receta'),
                controller: recetaController,
              ),
            ],
          ),
        ),

    );
  }
}
