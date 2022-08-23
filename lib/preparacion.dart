import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'db/acciones.dart';
import 'model/Ingrediente.dart';

class Prepracion extends StatefulWidget {
  final String nombre;
  final int id;
  const Prepracion(this.nombre,this.id,{Key key}) : super(key: key);

  @override
  State<Prepracion> createState() => _PrepracionState();
}

class _PrepracionState extends State<Prepracion> {
  var pesoController = TextEditingController();
  DataBase db = DataBase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Preparación de Receta'),),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.nombre,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),

            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Peso' ),
              controller: pesoController,
              textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  setState(() {
                    child: FutureBuilder<List>(
                        future: db.ingredientes(widget.id),
                        initialData: [],
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? _recetasListViewBuilder(context, snapshot)
                              : _waiting();
                        });
                  });
                }
            ),
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

  Widget _recetaTile(IngredienteModel ingrediente) {
    double valor = double.parse(ingrediente.valor);
    double peso;
    if(pesoController.text.isEmpty){
      peso = 0;
    }else{
      peso = double.parse(pesoController.text);
    }
    double total = valor * peso;

    return Container(
        child: ListTile(
            title: Text(ingrediente.name),
            subtitle: Text(ingrediente.valor.toString()),
            trailing: Text(total.toStringAsFixed(2)+ ' g',style: const TextStyle(
              fontSize: 20.0,
            ),),
            )
    );
  }
  Widget _waiting() {
    return const Center(
      child: Text("No existen ingredientes"),
    );
  }
}
