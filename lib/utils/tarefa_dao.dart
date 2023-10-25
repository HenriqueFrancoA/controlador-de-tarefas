import 'package:minhas_tarefas/models/categoria.dart';
import 'package:minhas_tarefas/models/tarefa.dart';
import 'package:minhas_tarefas/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TarefaDAO {
  Future<int> insertTarefa(Tarefa tarefa) async {
    final db = await DatabaseHelper().database;
    return await db.insert(
      'tb_tarefa',
      tarefa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTarefa(Tarefa tarefa) async {
    final db = await DatabaseHelper().database;
    return await db.update('tb_tarefa', tarefa.toMap(),
        where: 'id = ?', whereArgs: [tarefa.id]);
  }

  Future<List<Tarefa>> getAllTarefas() async {
    final db = await DatabaseHelper().database;

    const query = '''
    SELECT tb_tarefa.*, tb_categoria.id AS categoria_id, tb_categoria.nome AS categoria_nome
    FROM tb_tarefa
    LEFT JOIN tb_categoria ON tb_tarefa.categoria = tb_categoria.id
  ''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (index) {
      final categoriaNome = maps[index]['categoria_nome'];
      final categoriaId = maps[index]['categoria_id'];
      final categoria = categoriaNome != null && categoriaId != null
          ? Categoria(id: categoriaId, nome: categoriaNome)
          : null;
      return Tarefa.fromMap(maps[index], categoria);
    });
  }

  Future<int> deleteTarefa(String id) async {
    final db = await DatabaseHelper().database;
    return await db.delete('tb_tarefa', where: 'id = ?', whereArgs: [id]);
  }
}
