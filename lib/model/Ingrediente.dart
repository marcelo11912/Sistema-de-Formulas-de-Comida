class IngredienteModel {
  int _id;
  var _id_receta;
  String _name;
  var _valor;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  get id_receta => _id_receta;

   get valor => _valor;

  set valor( value) {
    _valor = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  set id_receta(value) {
    _id_receta = value;
  }


  IngredienteModel(this._id, this._id_receta, this._name, this._valor);

  IngredienteModel.create(this._id_receta,this._name, this._valor);

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'id_receta': _id_receta,
      'name': _name,
      'valor': _valor,
    };
  }

  // Implementa toString para que sea más fácil ver información sobre cada perro
  // usando la declaración de impresión.
  @override
  String toString() {
    return 'Ingrediente{id: $_id, idreceta: $_id_receta, name: $_name, valor: $_valor}';
  }
}
