class Modelo {
  int? id;
  int marcaId;
  String nombre;
  int anio;
  int cilindraje;
  double precio;

  Modelo({
    this.id,
    required this.marcaId,
    required this.nombre,
    required this.anio,
    required this.cilindraje,
    required this.precio,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'marca_id': marcaId,
      'nombre': nombre,
      'anio': anio,
      'cilindraje': cilindraje,
      'precio': precio,
    };
  }

  factory Modelo.fromMap(Map<String, dynamic> map) {
    return Modelo(
      id: map['id'] as int?,
      marcaId: map['marca_id'] as int,
      nombre: map['nombre'] as String,
      anio: map['anio'] as int,
      cilindraje: map['cilindraje'] as int,
      precio: (map['precio'] as num).toDouble(),
    );
  }
}
