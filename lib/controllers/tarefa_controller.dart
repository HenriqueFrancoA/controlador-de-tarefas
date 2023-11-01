import 'package:get/get.dart';
import 'package:minhas_tarefas/models/categoria.dart';
import 'package:minhas_tarefas/models/tarefa.dart';
import 'package:minhas_tarefas/utils/categoria_dao.dart';
import 'package:minhas_tarefas/utils/tarefa_dao.dart';

class TarefaController extends GetxController {
  RxList<Tarefa> todasTarefas = RxList<Tarefa>();
  RxList<Tarefa> tarefasFiltradas = RxList<Tarefa>();
  RxList<Tarefa> estaSemana = RxList<Tarefa>();
  RxList<Tarefa> diaSelecionado = RxList<Tarefa>();
  RxList<int> quantidadeTarefa = RxList<int>.filled(7, 0);

  DateTime dataAtual = DateTime.now();
  final TarefaDAO tarefaDAO = TarefaDAO();
  final CategoriaDAO categoriaDAO = CategoriaDAO();

  Future<List<Tarefa>> carregarTarefas() async {
    todasTarefas.addAll(await tarefaDAO.getAllTarefas());
    filtrarTarefasDaSemanaAtual(dataAtual);
    return todasTarefas;
  }

  filtrarTarefasDaSemanaAtual(DateTime dataSemana) {
    final inicioDoDia =
        DateTime(dataSemana.year, dataSemana.month, dataSemana.day);
    final firstDayOfWeek =
        inicioDoDia.subtract(Duration(days: inicioDoDia.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

    estaSemana.clear();
    estaSemana.addAll(todasTarefas.where((tarefa) {
      if (tarefa.desativado == true) {
        return false;
      }
      if (tarefa.recorrencia == "Todo dia") {
        return true;
      }
      if (tarefa.recorrencia == "Dias semana") {
        // if (tarefaData.weekday < 6) {
        return true;
        // }
      }
      if (tarefa.dataTarefa != null) {
        final tarefaData = tarefa.dataTarefa;
        if ((tarefaData!.isAfter(firstDayOfWeek) ||
                (tarefaData.day == firstDayOfWeek.day &&
                    tarefaData.month == firstDayOfWeek.month)) &&
            (tarefaData.isBefore(lastDayOfWeek) ||
                (tarefaData.day == lastDayOfWeek.day &&
                    tarefaData.month == lastDayOfWeek.month))) {
          return true;
        }
      }
      return false;
    }));
    estaSemana.sort((t1, t2) {
      final hora1 = int.parse(t1.horarioInicio.split(":")[0]);
      final minuto1 = int.parse(t1.horarioInicio.split(":")[1]);
      final hora2 = int.parse(t2.horarioInicio.split(":")[0]);
      final minuto2 = int.parse(t2.horarioInicio.split(":")[1]);

      if (hora1 != hora2) {
        return hora1 - hora2;
      } else {
        return minuto1 - minuto2;
      }
    });

    for (Tarefa tarefa in estaSemana) {
      if (tarefa.recorrencia == "Todo dia") {
        for (int x = 0; x < 7; x++) {
          quantidadeTarefa[x]++;
        }
      } else if (tarefa.recorrencia == "Dias semana") {
        for (int x = 0; x < 7; x++) {
          if (x < 5) {
            quantidadeTarefa[x]++;
          }
        }
      } else if (tarefa.dataTarefa != null) {
        quantidadeTarefa[tarefa.dataTarefa!.weekday - 1]++;
      }
    }

    filtrarTarefasDiaSelecionado(dataSemana.weekday);
  }

  Future<int> filtrarTarefasDiaSelecionado(int diaSemana) async {
    diaSelecionado.clear();
    for (Tarefa tarefa in estaSemana) {
      if (tarefa.recorrencia == "Todo dia") {
        diaSelecionado.add(tarefa);
      } else if (tarefa.recorrencia == "Dias semana") {
        if (diaSemana < 6) {
          diaSelecionado.add(tarefa);
        }
      } else if (tarefa.dataTarefa != null &&
          tarefa.dataTarefa!.weekday == diaSemana) {
        diaSelecionado.add(tarefa);
      }
    }
    return diaSelecionado.length;
  }

  carregarTodasTarefasFiltradas() {
    tarefasFiltradas.clear();
    tarefasFiltradas.addAll(todasTarefas);
  }

  Future<List<Tarefa>> carregarTarefasFiltradas(
    String? descricao,
    String? prioridade,
    String? recorrencia,
    String? categoria,
  ) async {
    tarefasFiltradas.clear();

    final filteredTarefas = todasTarefas.where((tarefa) {
      final matchesDescricao = descricao == null ||
          descricao.isEmpty ||
          tarefa.descricao?.toLowerCase().contains(descricao.toLowerCase()) ==
              true;
      final matchesPrioridade = prioridade == null ||
          prioridade.isEmpty ||
          tarefa.prioridade.toLowerCase() == prioridade.toLowerCase();
      final matchesRecorrencia = recorrencia == null ||
          recorrencia.isEmpty ||
          tarefa.recorrencia.toLowerCase() == recorrencia.toLowerCase();
      final matchesCategoria = categoria == null ||
          categoria.isEmpty ||
          (tarefa.categoria?.nome.toLowerCase() == categoria.toLowerCase());

      return matchesDescricao &&
          matchesPrioridade &&
          matchesRecorrencia &&
          matchesCategoria;
    });

    tarefasFiltradas.addAll(filteredTarefas);
    return tarefasFiltradas;
  }

  criarTarefa(Tarefa tarefa, String? categoria) async {
    final inicioDoDia =
        DateTime(dataAtual.year, dataAtual.month, dataAtual.day);
    final firstDayOfWeek =
        inicioDoDia.subtract(Duration(days: inicioDoDia.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

    if (categoria != null && categoria != '') {
      Categoria? cat;
      cat = await categoriaDAO.getCategoriaByNome(categoria);
      tarefa.categoria = cat;
    }

    int idTarefa = await tarefaDAO.insertTarefa(tarefa);
    tarefa.id = idTarefa;
    todasTarefas.add(tarefa);
    if (tarefa.recorrencia == "Todo dia") {
      estaSemana.add(tarefa);
    } else if (tarefa.recorrencia == "Dias semana") {
      // if (tarefa.dataTarefa.weekday < 6) {
      estaSemana.add(tarefa);

      // }
    } else if (tarefa.dataTarefa != null &&
        (tarefa.dataTarefa!.isAfter(firstDayOfWeek) ||
            (tarefa.dataTarefa!.day == firstDayOfWeek.day &&
                tarefa.dataTarefa!.month == firstDayOfWeek.month)) &&
        (tarefa.dataTarefa!.isBefore(lastDayOfWeek) ||
            (tarefa.dataTarefa!.day == lastDayOfWeek.day &&
                tarefa.dataTarefa!.month == lastDayOfWeek.month))) {
      estaSemana.add(tarefa);
    }
    await filtrarTarefasDaSemanaAtual(dataAtual);
    update();
  }

  Future<Tarefa> atualizarTarefa(Tarefa tarefa, String? categoria) async {
    if (categoria != null && categoria != '') {
      Categoria? cat;
      cat = await categoriaDAO.getCategoriaByNome(categoria);
      tarefa.categoria = cat;
    }
    try {
      await tarefaDAO.updateTarefa(tarefa);
      int index = todasTarefas.indexWhere((p) => p.id == tarefa.id);
      if (index != -1) {
        todasTarefas[index] = tarefa;
        todasTarefas.refresh();
      }

      update();
      return tarefa;
    } catch (e) {
      return tarefa;
    }
  }
}
