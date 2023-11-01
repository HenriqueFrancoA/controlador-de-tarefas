import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minhas_tarefas/models/financa.dart';
import 'package:sizer/sizer.dart';

class VisualizarFinancaScreen extends StatefulWidget {
  const VisualizarFinancaScreen({Key? key}) : super(key: key);

  @override
  VisualizarFinancaScreenState createState() => VisualizarFinancaScreenState();
}

class VisualizarFinancaScreenState extends State<VisualizarFinancaScreen> {
  final financa = Get.arguments['financa'] as Financa;

  final dateFormat = DateFormat('dd/MMM/yy', 'pt_BR');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/home_financas');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: IconButton(
            onPressed: () {
              Get.offNamed('/home_financas');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => Get.offNamed('/entrada', arguments: {
                "financa": financa,
              }),
              child: Text(
                "Editar",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.all(15),
          width: 100.w,
          height: 100.h,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        financa.descricao != ''
                            ? financa.descricao!
                            : 'Sem descrição',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Data: ${dateFormat.format(financa.dataFinanca)}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "Recorrência: ${financa.recorrencia}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        financa.qtdRecorrencia != null
                            ? Text(
                                "quantidade: ${financa.qtdRecorrencia} vezes",
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 35.h,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Notas",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 100.w,
                      height: 34.h - 43,
                      padding: const EdgeInsets.all(10),
                      child: Expanded(
                        child: Text(
                          financa.notas != ''
                              ? financa.notas!
                              : 'Nenhuma nota.',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
