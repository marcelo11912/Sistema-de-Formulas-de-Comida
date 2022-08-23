class Receta {
    int id;
    String name;

   Receta(this.name);

    Receta.edit(this.id, this.name);

  Receta.fromMap(dynamic obj) {
     this.id = obj["id"];
     this.name = obj["name"];
   }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    return map;

  }
  // Implementa toString para que sea más fácil ver información sobre cada perro
  // usando la declaración de impresión.
  @override
  String toString() {
    return 'Receta{id: $id, name: $name}';
  }
}

