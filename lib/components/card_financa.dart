import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:minhas_tarefas/models/financa.dart';

class CardFinanca extends StatefulWidget {
  final Financa financa;
  const CardFinanca({
    Key? key,
    required this.financa,
  }) : super(key: key);

  @override
  CardFinancaState createState() => CardFinancaState();
}

class CardFinancaState extends State<CardFinanca> {
  @override
  Widget build(BuildContext context) {
    String? descricao = widget.financa.descricao?.toUpperCase();
    if (descricao != null) {
      if (descricao.length > 20) {
        descricao = '${descricao.substring(0, 20)}...';
      }
    }
    return GestureDetector(
      onTap: () {
        Get.offNamed('/visualizar_financa', arguments: {
          'financa': widget.financa,
        });
      },
      child: Container(
        height: 75,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
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
                  height: 35,
                  child: LottieBuilder.asset(
                    widget.financa.entrada
                        ? "assets/entrada_dinheiro.json"
                        : "assets/saida_dinheiro.json",
                    fit: BoxFit.contain,
                    repeat: false,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.financa.recorrencia,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'R\$${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(widget.financa.valor)}',
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
