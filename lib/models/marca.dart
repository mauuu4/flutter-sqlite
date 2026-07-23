class Marca {
  int? id;
  String nombre;
  String pais;

  Marca({this.id, required this.nombre, required this.pais});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'pais': pais,
    };
  }

  factory Marca.fromMap(Map<String, dynamic> map) {
    return Marca(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      pais: map['pais'] as String,
    );
  }
}
