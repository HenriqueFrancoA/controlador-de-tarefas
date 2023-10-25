import 'package:minhas_tarefas/models/categoria.dart';

class Tarefa {
  int? id;
  String? descricao;
  String prioridade;
  DateTime dataTarefa;
  String horarioInicio;
  String? horarioFim;
  Categoria? categoria;
  String recorrencia;
  String? notas;

  Tarefa(
      {this.id,
      this.descricao,
      required this.prioridade,
      required this.dataTarefa,
      required this.horarioInicio,
      this.horarioFim,
      this.categoria,
      required this.recorrencia,
      this.notas});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prioridade': prioridade,
      'descricao': descricao,
      'data_tarefa': dataTarefa.millisecondsSinceEpoch,
      'horario_inicio': horarioInicio,
      'horario_fim': horarioFim,
      'categoria': categoria != null ? categoria!.id : null,
      'recorrencia': recorrencia,
      'notas': notas,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map, Categoria? categoria) {
    int? date;
    date = map['data_tarefa'];
    return Tarefa(
      id: map['id'],
      prioridade: map['prioridade'],
      descricao: map['descricao'],
      dataTarefa: DateTime.fromMillisecondsSinceEpoch(date!),
      horarioInicio: map['horario_inicio'],
      horarioFim: map['horario_fim'],
      categoria: categoria,
      recorrencia: map['recorrencia'],
      notas: map['notas'],
    );
  }
}
