import '../models/marca.dart';
import 'db_helper.dart';

class MarcaService {
  static const String _tableName = 'marcas';

  static Future<int> createMarca(Marca marca) async {
    final db = await DBHelper.database;
    return await db!.insert(_tableName, marca.toMap());
  }

  static Future<List<Marca>> getMarcas() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query(_tableName);
    return List.generate(maps.length, (index) => Marca.fromMap(maps[index]));
  }

  static Future<int> updateMarca(Marca marca) async {
    final db = await DBHelper.database;
    return await db!.update(
      _tableName,
      marca.toMap(),
      where: 'id = ?',
      whereArgs: [marca.id],
    );
  }

  static Future<int> deleteMarca(int id) async {
    final db = await DBHelper.database;
    return await db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
