import '../models/modelo.dart';
import 'db_helper.dart';

class ModeloService {
  static const String _tableName = 'modelos';

  static Future<int> createModelo(Modelo modelo) async {
    final db = await DBHelper.database;
    return await db!.insert(_tableName, modelo.toMap());
  }

  static Future<List<Modelo>> getModelosByMarca(int marcaId) async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      _tableName,
      where: 'marca_id = ?',
      whereArgs: [marcaId],
    );
    return List.generate(maps.length, (index) => Modelo.fromMap(maps[index]));
  }

  static Future<int> updateModelo(Modelo modelo) async {
    final db = await DBHelper.database;
    return await db!.update(
      _tableName,
      modelo.toMap(),
      where: 'id = ?',
      whereArgs: [modelo.id],
    );
  }

  static Future<int> deleteModelo(int id) async {
    final db = await DBHelper.database;
    return await db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
