import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Clase para representar los registros del historial
class GameHistory {
  final int? id;
  final String name;
  final int score;
  final DateTime date;

  GameHistory({
    this.id,
    required this.name,
    required this.score,
    required this.date,
  });

  // Convertir un objeto en un mapa para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'date': date.toIso8601String(),
    };
  }

  // Crear un objeto a partir de un mapa de SQLite
  static GameHistory fromMap(Map<String, dynamic> map) {
    return GameHistory(
      id: map['id'],
      name: map['name'],
      score: map['score'],
      date: DateTime.parse(map['date']),
    );
  }
}

class DBHelper {
  static const _databaseName = 'game_history.db';
  static const _tableName = 'history';
  static const _databaseVersion = 1;

  static final DBHelper instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        score INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  // Método para agregar un registro
  Future<int> insertGame(GameHistory game) async {
    final db = await database;
    return db.insert(_tableName, game.toMap());
  }

  // Método para obtener todos los registros
  Future<List<GameHistory>> getAllGames() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName, orderBy: 'date DESC');
    return maps.map((map) => GameHistory.fromMap(map)).toList();
  }

  // Método para eliminar un registro por ID
  Future<int> deleteGame(int id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Método para actualizar un registro
  Future<int> updateGame(GameHistory game) async {
    final db = await database;
    return db.update(
      _tableName,
      game.toMap(),
      where: 'id = ?',
      whereArgs: [game.id],
    );
  }

  // Método para eliminar todos los registros (opcional)
  Future<int> clearHistory() async {
    final db = await database;
    return db.delete(_tableName);
  }
}
