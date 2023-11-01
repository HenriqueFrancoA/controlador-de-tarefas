import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:minhas_tarefas/models/tarefa.dart';

class CardTarefa extends StatefulWidget {
  final Tarefa tarefa;
  const CardTarefa({
    Key? key,
    required this.tarefa,
  }) : super(key: key);

  @override
  CardTarefaState createState() => CardTarefaState();
}

class CardTarefaState extends State<CardTarefa> {
  @override
  Widget build(BuildContext context) {
    int hora = int.parse(widget.tarefa.horarioInicio.substring(0, 2));

    String? descricao = widget.tarefa.descricao?.toUpperCase();
    if (descricao != null) {
      if (descricao.length > 20) {
        descricao = '${descricao.substring(0, 20)}...';
      }
    }
    Color corPrioridade = Theme.of(context).colorScheme.onSecondary;
    if (widget.tarefa.prioridade == 'Alta') {
      corPrioridade = Theme.of(context).colorScheme.secondary;
    } else if (widget.tarefa.prioridade == 'Média') {
      corPrioridade = Theme.of(context).colorScheme.primary;
    } else if (widget.tarefa.prioridade == 'Baixa') {
      corPrioridade = Theme.of(context).colorScheme.onPrimary;
    }
    return GestureDetector(
      onTap: () => Get.toNamed('/visualizar', arguments: {
        'tarefa': widget.tarefa,
      }),
      child: Container(
        height: 75,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: corPrioridade,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  descricao ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 30,
                  child: LottieBuilder.asset(
                    repeat: false,
                    hora > 5 && hora < 18
                        ? "assets/dia.json"
                        : "assets/noite.json",
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.tarefa.recorrencia,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  widget.tarefa.horarioInicio,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
