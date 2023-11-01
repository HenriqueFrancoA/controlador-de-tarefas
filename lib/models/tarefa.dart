import 'package:minhas_tarefas/models/categoria.dart';

class Tarefa {
  int? id;
  String? descricao;
  String prioridade;
  DateTime? dataTarefa;
  String horarioInicio;
  String? horarioFim;
  Categoria? categoria;
  String recorrencia;
  String? notas;
  bool desativado;

  Tarefa(
      {this.id,
      this.descricao,
      required this.prioridade,
      this.dataTarefa,
      required this.horarioInicio,
      this.horarioFim,
      this.categoria,
      required this.recorrencia,
      this.notas,
      required this.desativado});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prioridade': prioridade,
      'descricao': descricao,
      'data_tarefa':
          dataTarefa != null ? dataTarefa!.millisecondsSinceEpoch : dataTarefa,
      'horario_inicio': horarioInicio,
      'horario_fim': horarioFim,
      'categoria': categoria != null ? categoria!.id : null,
      'recorrencia': recorrencia,
      'notas': notas,
      'desativado': desativado ? 1 : 0,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map, Categoria? categoria) {
    int? date;
    date = map['data_tarefa'];

    int des = map['desativado'];
    return Tarefa(
      id: map['id'],
      prioridade: map['prioridade'],
      descricao: map['descricao'],
      dataTarefa:
          date != null ? DateTime.fromMillisecondsSinceEpoch(date) : null,
      horarioInicio: map['horario_inicio'],
      horarioFim: map['horario_fim'],
      categoria: categoria,
      recorrencia: map['recorrencia'],
      notas: map['notas'],
      desativado: des == 1 ? true : false,
    );
  }
}
