import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String sql1 = "CREATE TABLE recetas(id INTEGER PRIMARY KEY, name TEXT)";
  String sql2 = "CREATE TABLE ingredientes(id INTEGER PRIMARY KEY, id_receta INTEGER,name TEXT, valor INTEGER, FOREIGN KEY(id_receta) REFERENCES recetas(id))";

  List queries = [sql1, sql2];
  final database = openDatabase(
    // Establecer la ruta a la base de datos. Nota: Usando la función `join` del
    // complemento `path` es la mejor práctica para asegurar que la ruta sea correctamente
    // construida para cada plataforma.

    join(await getDatabasesPath(), 'test_database.db'),
    // Cuando la base de datos se crea por primera vez, crea una tabla para almacenar dogs
    onCreate: (db, version) async {
      for(String query in queries){
        await db.execute(query);
      }
    },

    // Establece la versión. Esto ejecuta la función onCreate y proporciona una
    // ruta para realizar actualizacones y defradaciones en la base de datos.
    version: 1,
  );

  Future<void> insertDog(Receta dog) async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Inserta el Dog en la tabla correcta. También puede especificar el
    // `conflictAlgorithm` para usar en caso de que el mismo Dog se inserte dos veces.
    // En este caso, reemplaza cualquier dato anterior.
    await db.insert(
      'recetas',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertIngrediente(Ingrediente ingrediente) async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Inserta el Dog en la tabla correcta. También puede especificar el
    // `conflictAlgorithm` para usar en caso de que el mismo Dog se inserte dos veces.
    // En este caso, reemplaza cualquier dato anterior.
    await db.insert(
      'ingredientes',
      ingrediente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Receta>> dogs() async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Consulta la tabla por todos los Dogs.
    final List<Map<String, dynamic>> maps = await db.query('recetas');

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return Receta(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<List<Ingrediente>> ingredientes() async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Consulta la tabla por todos los Dogs.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT ing.id,rec.name,ing.name,ing.valor FROM Ingredientes ing INNER JOIN Recetas rec ON rec.id=ing.id_receta");

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return Ingrediente(
        id: maps[i]['id'],
        id_receta: maps[i]['name'],
        name: maps[i]['name'],
        valor: maps[i]['valor'],
      );
    });
  }

  Future<void> updateDog(Receta dog) async {
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Actualiza el Dog dado
    await db.update(
      'recetas',
      dog.toMap(),
      // Aseguúrate de que solo actualizarás el Dog con el id coincidente
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(Receta dog, int id) async {
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Elimina el Dog de la base de datos
    await db.delete(
      'recetas',
      // Utiliza la cláusula `where` para eliminar un dog específico
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [dog.id],
    );
  }

  var fido = Receta(id: 1, name: 'Alitas');
  var alitas = Ingrediente(
    id: 1,
    id_receta: 1,
    name: 'sal',
    valor: 200,
  );

  // Inserta un dog en la base de datos
  await insertDog(fido);

  await insertIngrediente(alitas);

  // Imprime la lista de dogs (solamente Fido por ahora)
  print("Mi receta");
  print(await dogs());

  print("Mi ingrediente");
  print(await ingredientes());

  // Actualiza la edad de Fido y lo guarda en la base de datos
  fido = Receta(
    id: fido.id,
    name: fido.name,
  );
  await updateDog(fido);

  // Imprime la información de Fido actualizada
  print(await dogs());

  // Elimina a Fido de la base de datos
  await deleteDog(fido, fido.id);

  // Imprime la lista de dos (vacía)
  print(await dogs());
}

class Receta {
  final int id;
  final String name;

  Receta({this.id,  this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Implementa toString para que sea más fácil ver información sobre cada perro
  // usando la declaración de impresión.
  @override
  String toString() {
    return 'Receta{id: $id, name: $name}';
  }
}

class Ingrediente {
  final int id;
  var id_receta;
  final String name;
  final int valor;

  Ingrediente(
      { this.id,
       this.id_receta,
       this.name,
       this.valor});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_receta': id_receta,
      'name': name,
      'valor': valor,
    };
  }

  // Implementa toString para que sea más fácil ver información sobre cada perro
  // usando la declaración de impresión.
  @override
  String toString() {
    return 'Ingrediente{id: $id, idreceta: $id_receta, name: $name, valor: $valor}';
  }
}
