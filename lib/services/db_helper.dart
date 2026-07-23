import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper{
  static Database? _db;
  static Future<Database?> get database async{
    if(_db != null){
      return _db;
    }
    _db = await initDB();
    return _db;
  }
  static Future<Database> initDB() async{
    String path = kIsWeb
        ? 'motos_database.db'
        : join(await getDatabasesPath(), 'motos_database.db');
    return await openDatabase(
      path,
      version: 3,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _createTables(db);
        if (oldVersion < 3) {
          await _addColumnIfMissing(db, 'marcas', 'pais', "TEXT NOT NULL DEFAULT ''");
          await _addColumnIfMissing(db, 'modelos', 'cilindraje', 'INTEGER NOT NULL DEFAULT 0');
          await _addColumnIfMissing(db, 'modelos', 'precio', 'REAL NOT NULL DEFAULT 0');
        }
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS marcas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        pais TEXT NOT NULL DEFAULT ''
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS modelos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        marca_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        anio INTEGER NOT NULL,
        cilindraje INTEGER NOT NULL DEFAULT 0,
        precio REAL NOT NULL DEFAULT 0,
        FOREIGN KEY (marca_id) REFERENCES marcas (id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<void> _addColumnIfMissing(
    Database db,
    String table,
    String column,
    String definition,
  ) async {
    final info = await db.rawQuery('PRAGMA table_info($table)');
    final exists = info.any((row) => row['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $definition');
    }
  }

  static Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }

}