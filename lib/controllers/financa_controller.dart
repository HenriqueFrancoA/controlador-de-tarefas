import 'package:get/get.dart';
import 'package:minhas_tarefas/models/financa.dart';
import 'package:minhas_tarefas/utils/categoria_dao.dart';
import 'package:minhas_tarefas/utils/financa_dao.dart';

class FinancaController extends GetxController {
  RxList<Financa> todasFinancas = RxList<Financa>();
  RxList<Financa> financasFiltradas = RxList<Financa>();
  RxList<Financa> esteMes = RxList<Financa>();
  RxList<Financa> semanaSelecionada = RxList<Financa>();
  RxList<Financa> diaSelecionado = RxList<Financa>();
  RxList<double> quantidadeFinancaPorSemana = RxList<double>.filled(5, 0);
  RxList<double> quantidadeFinancaPorDia = RxList<double>.filled(7, 0);

  DateTime? inicioPrimeiraSemana;
  DateTime? fimPrimeiraSemana;
  DateTime? inicioSegundaSemana;
  DateTime? fimSegundaSemana;
  DateTime? inicioTerceiraSemana;
  DateTime? fimTerceiraSemana;
  DateTime? inicioQuartaSemana;
  DateTime? fimQuartaSemana;
  DateTime? inicioQuintaSemana;
  DateTime? fimQuintaSemana;

  RxList<RxList<Financa>> listaSemanas = RxList<RxList<Financa>>();

  DateTime hoje = DateTime.now();
  final FinancaDAO financaDAO = FinancaDAO();
  final CategoriaDAO categoriaDAO = CategoriaDAO();

  Future<bool> dentroDestaSemana(DateTime dia, DateTime tarefaData) async {
    final inicioDoDia = DateTime(dia.year, dia.month, dia.day);
    final primeiroDiaDaSemana =
        inicioDoDia.subtract(Duration(days: inicioDoDia.weekday - 1));
    final ultimoDiaSemana = primeiroDiaDaSemana.add(const Duration(days: 6));

    if ((tarefaData.isAfter(primeiroDiaDaSemana) ||
            (tarefaData.day == primeiroDiaDaSemana.day &&
                tarefaData.month == primeiroDiaDaSemana.month)) &&
        (tarefaData.isBefore(ultimoDiaSemana) ||
            (tarefaData.day == ultimoDiaSemana.day &&
                tarefaData.month == ultimoDiaSemana.month))) {
      print('esse foi $dia nessa semana $tarefaData');
      return true;
    } else {
      return false;
    }
  }

  Future<List<Financa>> carregarFinancas() async {
    todasFinancas.addAll(await financaDAO.getAllFinancas());

    return todasFinancas;
  }

  montarMes() {
    inicioPrimeiraSemana = DateTime(hoje.year, hoje.month, 1);
    final ultimo = inicioPrimeiraSemana!
        .subtract(Duration(days: inicioPrimeiraSemana!.weekday - 1));
    fimPrimeiraSemana = ultimo.add(const Duration(days: 6));

    inicioSegundaSemana = fimPrimeiraSemana!.add(const Duration(days: 1));
    fimSegundaSemana = inicioSegundaSemana!.add(const Duration(days: 6));

    inicioTerceiraSemana = fimSegundaSemana!.add(const Duration(days: 1));
    fimTerceiraSemana = inicioTerceiraSemana!.add(const Duration(days: 6));

    inicioQuartaSemana = fimTerceiraSemana!.add(const Duration(days: 1));
    fimQuartaSemana = inicioQuartaSemana!.add(const Duration(days: 6));

    inicioQuintaSemana = fimQuartaSemana!.add(const Duration(days: 1));
    fimQuintaSemana = inicioQuintaSemana!.add(const Duration(days: 6));
  }

  int verificaSemana(DateTime data) {
    if ((data.isAfter(inicioPrimeiraSemana!) || (data.day == inicioPrimeiraSemana!.day && data.month == inicioPrimeiraSemana!.month)) &&
            (data.isBefore(fimPrimeiraSemana!)) ||
        (data.day == fimPrimeiraSemana!.day &&
            data.month == fimPrimeiraSemana!.month)) {
      return 0;
    } else if ((data.isAfter(inicioSegundaSemana!) ||
                (data.day == inicioSegundaSemana!.day &&
                    data.month == inicioSegundaSemana!.month)) &&
            (data.isBefore(fimSegundaSemana!)) ||
        (data.day == fimSegundaSemana!.day &&
            data.month == fimSegundaSemana!.month)) {
      return 1;
    } else if ((data.isAfter(inicioTerceiraSemana!) ||
                (data.day == inicioTerceiraSemana!.day &&
                    data.month == inicioTerceiraSemana!.month)) &&
            (data.isBefore(fimTerceiraSemana!)) ||
        (data.day == fimTerceiraSemana!.day &&
            data.month == fimTerceiraSemana!.month)) {
      return 2;
    } else if ((data.isAfter(inicioQuartaSemana!) || (data.day == inicioQuartaSemana!.day && data.month == inicioQuartaSemana!.month)) && (data.isBefore(fimQuartaSemana!)) ||
        (data.day == fimQuartaSemana!.day &&
            data.month == fimQuartaSemana!.month)) {
      return 3;
    } else if ((data.isAfter(inicioQuintaSemana!) ||
                (data.day == inicioQuintaSemana!.day && data.month == inicioQuintaSemana!.month)) &&
            (data.isBefore(fimQuintaSemana!)) ||
        (data.day == fimQuintaSemana!.day && data.month == fimQuintaSemana!.month)) {
      return 4;
    }
    return 5;
  }

  filtrarFinancasDoMesAtual() {
    montarMes();
    esteMes.clear();
    esteMes.addAll(todasFinancas.where((tarefa) {
      if (tarefa.recorrencia == 'Mensal') {
        if (tarefa.qtdRecorrencia == null) {
          return true;
        } else {
          int novoMes = tarefa.dataFinanca.month;
          for (int x = 0; x <= tarefa.qtdRecorrencia!; x++) {
            if (novoMes >= 13) {
              novoMes -= 12;
            }
            if (novoMes == hoje.month) {
              return true;
            }
            novoMes++;
          }
        }
      }
      if (tarefa.dataFinanca.month.isEqual(hoje.month)) {
        return true;
      }
      return false;
    }));
    int index;
    quantidadeFinancaPorSemana = RxList<double>.filled(5, 0);
    DateTime dataComMesAtual;
    for (Financa financa in esteMes) {
      dataComMesAtual =
          DateTime(hoje.year, hoje.month, financa.dataFinanca.day);
      index = verificaSemana(dataComMesAtual);
      if (index != 5) {
        if (financa.entrada) {
          quantidadeFinancaPorSemana[index] += financa.valor;
        } else {
          quantidadeFinancaPorSemana[index] -= financa.valor;
        }
      }
    }
  }

  filtrarFinancasSemanaSelecionada(int semana) {
    quantidadeFinancaPorDia = RxList<double>.filled(7, 0);
    semanaSelecionada.clear();
    int index;
    DateTime dataComMesAtual;
    for (Financa financa in esteMes) {
      dataComMesAtual =
          DateTime(hoje.year, hoje.month, financa.dataFinanca.day);
      index = verificaSemana(dataComMesAtual);
      if (index == semana) {
        semanaSelecionada.add(financa);
      }
    }

    for (Financa financa in semanaSelecionada) {
      if (financa.entrada) {
        quantidadeFinancaPorDia[financa.dataFinanca.weekday - 1] +=
            financa.valor;
      } else {
        quantidadeFinancaPorDia[financa.dataFinanca.weekday - 1] -=
            financa.valor;
      }
    }
  }

  filtrarFinancasDiaSelecionado(int dia) {
    diaSelecionado.clear();

    for (Financa financa in semanaSelecionada) {
      if (financa.dataFinanca.weekday == dia) {
        diaSelecionado.add(financa);
      }
    }
  }

  carregarTodasFinancasFiltradas() {
    financasFiltradas.clear();
    financasFiltradas.addAll(todasFinancas);
  }

  Future<List<Financa>> carregarTarefasFiltradas(
    String? descricao,
    String? recorrencia,
  ) async {
    financasFiltradas.clear();

    final filteredTarefas = todasFinancas.where((tarefa) {
      final matchesDescricao = descricao == null ||
          descricao.isEmpty ||
          tarefa.descricao?.toLowerCase().contains(descricao.toLowerCase()) ==
              true;

      final matchesRecorrencia = recorrencia == null ||
          recorrencia.isEmpty ||
          tarefa.recorrencia.toLowerCase() == recorrencia.toLowerCase();

      return matchesDescricao && matchesRecorrencia;
    });

    financasFiltradas.addAll(filteredTarefas);
    return financasFiltradas;
  }

  criarFinanca(Financa financa) async {
    int idFinanca = await financaDAO.insertFinanca(financa);
    financa.id = idFinanca;
    todasFinancas.add(financa);

    if (financa.dataFinanca.month == hoje.month) {
      esteMes.add(financa);
      await filtrarFinancasDoMesAtual();
    }

    update();
  }

  Future<Financa> atualizarFinanca(Financa financa) async {
    try {
      await financaDAO.updateFinanca(financa);
      int index = todasFinancas.indexWhere((f) => f.id == financa.id);
      if (index != -1) {
        todasFinancas[index] = financa;
        todasFinancas.refresh();
      }

      update();
      return financa;
    } catch (e) {
      return financa;
    }
  }
}
