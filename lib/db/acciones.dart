import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/Ingrediente.dart';
import '../model/Receta.dart';



class DataBase {
  var database;

   db() async{
    String sql1 = "CREATE TABLE recetas(id INTEGER  PRIMARY KEY AUTOINCREMENT, name  TEXT NOT NULL)";
    String sql2 = "CREATE TABLE ingredientes(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, id_receta INTEGER NOT NULL,name TEXT NOT NULL, valor TEXT NOT NULL, FOREIGN KEY(id_receta) REFERENCES recetas(id))";
    List queries = [sql1, sql2];
    database = openDatabase(
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

    print(database);
  }


  Future<void> insertReceta(Receta receta) async {
    // Obtiene una referencia de la base de datos
    await this.db();
    final Database db = await database;

    // Inserta el Dog en la tabla correcta. También puede especificar el
    // `conflictAlgorithm` para usar en caso de que el mismo Dog se inserte dos veces.
    // En este caso, reemplaza cualquier dato anterior.
    await db.insert(
      'recetas',
      receta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertIngrediente(IngredienteModel ingrediente) async {
    await this.db();
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

  Future<List<Receta>> recetas() async {
    // Obtiene una referencia de la base de datos
    await this.db();
    final Database db = await database;

    // Consulta la tabla por todos los Dogs.
    var objects = await db.query('recetas');

    // Convierte List<Map<String, dynamic> en List<Dog>.
    List<Receta> recetas = objects.isNotEmpty ? objects.map((obj) => Receta.fromMap(obj)).toList()
        : null;
    return recetas;
  }

  Future<List<IngredienteModel>> ingredientes(int id) async {
    await this.db();
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Consulta la tabla por todos los Dogs.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT id,id_receta,name,valor FROM Ingredientes WHERE id_receta='$id'");

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return IngredienteModel(
        maps[i]['id'],
        maps[i]['id_receta'],
        maps[i]['name'],
        maps[i]['valor'],
      );
    });
  }

  Future<void> updateReceta(Receta receta) async {
    await this.db();
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Actualiza el Dog dado
    await db.update(
      'recetas',
      receta.toMap(),
      // Aseguúrate de que solo actualizarás el Dog con el id coincidente
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [receta.id],
    );
  }

  Future<void> updateIngrediente(IngredienteModel ingrediente) async {
    await this.db();
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Actualiza el Dog dado
    await db.update(
      'ingredientes',
      ingrediente.toMap(),
      // Aseguúrate de que solo actualizarás el Dog con el id coincidente
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [ingrediente.id],
    );
  }

  Future<void> deleteRecetas(Receta receta, int id) async {
    await this.db();
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Elimina el Dog de la base de datos
    await db.delete(
      'recetas',
      // Utiliza la cláusula `where` para eliminar un dog específico
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [receta.id],
    );
  }

  Future<void> deleteIngrediente(IngredienteModel ingrediente, int id) async {
    await this.db();
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Elimina el Dog de la base de datos
    await db.delete(
      'ingredientes',
      // Utiliza la cláusula `where` para eliminar un dog específico
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [ingrediente.id],
    );
  }

}
