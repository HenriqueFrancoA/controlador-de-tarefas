import 'package:minhas_tarefas/models/financa.dart';
import 'package:minhas_tarefas/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class FinancaDAO {
  Future<int> insertFinanca(Financa financa) async {
    final db = await DatabaseHelper().database;
    return await db.insert(
      'tb_financa',
      financa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateFinanca(Financa financa) async {
    final db = await DatabaseHelper().database;
    return await db.update('tb_financa', financa.toMap(),
        where: 'id = ?', whereArgs: [financa.id]);
  }

  Future<List<Financa>> getAllFinancas() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('tb_financa');

    return List.generate(maps.length, (index) => Financa.fromMap(maps[index]));
  }

  Future<int> deleteFinanca(String id) async {
    final db = await DatabaseHelper().database;
    return await db.delete('tb_financa', where: 'id = ?', whereArgs: [id]);
  }
}
