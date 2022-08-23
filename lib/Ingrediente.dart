import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/model/Ingrediente.dart';

import 'db/acciones.dart';
import 'ingredientes.dart';

class Ingredientes extends StatefulWidget {
   String nombre;
   int id;
   bool update;
   int idIngrediente;
   String ingrediente = "";
   var valor= "";
  Ingredientes(this.nombre,this.id,this.idIngrediente,this.ingrediente,this.valor, this.update,{Key key}) : super(key: key);

  @override
  State<Ingredientes> createState() => _IngredientesState();
}

class _IngredientesState extends State<Ingredientes> {
  DataBase db = DataBase();

  @override
  Widget build(BuildContext context) {
    var ingredienteController = TextEditingController(text: widget.ingrediente);
    var valorController = TextEditingController(text: widget.valor.toString());


    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingredientes"),
        actions: <Widget>[
          TextButton(
            style: style,
            onPressed: () {
              if(widget.update){
                IngredienteModel ingrediente = IngredienteModel(widget.idIngrediente,widget.id,ingredienteController.text, valorController.text);
                db.updateIngrediente(ingrediente);
              }else{
                IngredienteModel ingrediente = IngredienteModel.create(widget.id,ingredienteController.text, valorController.text);
                db.insertIngrediente(ingrediente);
              }
              Navigator.pop(context);
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
                controller: ingredienteController,
                decoration:
                    const InputDecoration(hintText: 'Nombre del ingrediente')),
            TextFormField(
              controller: valorController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: 'Valor del ingrediente'),
            ),
          ],
        ),
      ),
    );
  }
}
