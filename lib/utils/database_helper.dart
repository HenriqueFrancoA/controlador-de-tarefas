import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = "minhas-tarefas.db";
  static const int _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE tb_tarefa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        prioridade TEXT,
        descricao TEXT,
        data_tarefa INTEGER,
        horario_inicio TEXT,
        horario_fim TEXT,
        categoria INTEGER,
        recorrencia TEXT,
        notas TEXT,
        FOREIGN KEY(categoria) REFERENCES tb_categoria(id)
      )
    """);

    await db.execute("""
      CREATE TABLE tb_categoria (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT
      )
    """);

    await db.execute("""
      CREATE TABLE tb_financa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT,
        notas TEXT,
        valor DOUBLE,
        recorrencia TEXT,
        qtd_recorrencia INTEGER,
        data_financa INTEGER,
        entrada INTEGER
      )
    """);
  }
}
