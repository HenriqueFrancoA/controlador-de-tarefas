import 'package:minhas_tarefas/models/categoria.dart';
import 'package:minhas_tarefas/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaDAO {
  Future<int> insertCategoria(Categoria categoria) async {
    final db = await DatabaseHelper().database;
    return await db.insert(
      'tb_categoria',
      categoria.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCategoria(Categoria categoria) async {
    final db = await DatabaseHelper().database;
    return await db.update('tb_categoria', categoria.toMap(),
        where: 'id = ?', whereArgs: [categoria.id]);
  }

  Future<List<Categoria>> getCategoriaById(int id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps =
        await db.query('tb_categoria', where: 'id = ?', whereArgs: [id]);
    return List.generate(
        maps.length, (index) => Categoria.fromMap(maps[index]));
  }

  Future<Categoria> getCategoriaByNome(String nome) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps =
        await db.query('tb_categoria', where: 'nome = ?', whereArgs: [nome]);
    return List.generate(maps.length, (index) => Categoria.fromMap(maps[index]))
        .first;
  }

  Future<List<Categoria>> getAllCategorias() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('tb_categoria');

    return List.generate(
        maps.length, (index) => Categoria.fromMap(maps[index]));
  }

  Future<int> deleteCategoria(String id) async {
    final db = await DatabaseHelper().database;
    return await db.delete('tb_categoria', where: 'id = ?', whereArgs: [id]);
  }
}
