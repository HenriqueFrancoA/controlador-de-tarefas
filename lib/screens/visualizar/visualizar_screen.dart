import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minhas_tarefas/models/tarefa.dart';
import 'package:sizer/sizer.dart';

class VisualizarScreen extends StatefulWidget {
  const VisualizarScreen({Key? key}) : super(key: key);

  @override
  VisualizarScreenState createState() => VisualizarScreenState();
}

class VisualizarScreenState extends State<VisualizarScreen> {
  final tarefa = Get.arguments['tarefa'] as Tarefa;

  double widthContainerColorido = (100.w - 50) / 4;

  final dateFormat = DateFormat('dd/MMM', 'pt_BR');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.offNamed('/agendar', arguments: {
              "tarefa": tarefa,
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
                      tarefa.descricao != ''
                          ? tarefa.descricao!
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
                      "Data: ${dateFormat.format(tarefa.dataTarefa)}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Horário: ${tarefa.horarioInicio}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      tarefa.horarioFim != null
                          ? Text(
                              "Término: ${tarefa.horarioFim}",
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "Categoria: ${tarefa.categoria != null ? tarefa.categoria?.nome : "Sem categoria"}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "Recorrência: ${tarefa.recorrencia}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      tarefa.prioridade == 'Alta'
                          ? Column(
                              children: [
                                Text(
                                  'Alta',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Container(
                                  height: 30,
                                  width: widthContainerColorido,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  'Alta',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.grey[400],
                                      ),
                                ),
                                Container(
                                  height: 30,
                                  width: widthContainerColorido,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(141, 255, 255, 255),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                  ),
                                ),
                              ],
                            ),
                      tarefa.prioridade == 'Média'
                          ? Column(
                              children: [
                                Text(
                                  'Média',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Container(
                                  height: 30,
                                  width: widthContainerColorido,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  'Média',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.grey[400],
                                      ),
                                ),
                                Container(
                                  height: 30,
                                  width: widthContainerColorido,
                                  color:
                                      const Color.fromARGB(141, 255, 255, 255),
                                ),
                              ],
                            ),
                      tarefa.prioridade == 'Baixa'
                          ? Column(
                              children: [
                                Text(
                                  'Baixa',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Container(
                                  height: 30,
                                  width: widthContainerColorido,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  'Baixa',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.grey[400],
                                      ),
                                ),
                                Container(
                                  height: 30,
                                  width: widthContainerColorido,
                                  color:
                                      const Color.fromARGB(141, 255, 255, 255),
                                ),
                              ],
                            ),
                      tarefa.prioridade == 'Sem prioridade'
                          ? Column(
                              children: [
                                Text(
                                  'Nenhuma',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Container(
                                  height: 30,
                                  width: widthContainerColorido,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  'Nenhuma',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.grey[400],
                                      ),
                                ),
                                Container(
                                  height: 30,
                                  width: widthContainerColorido,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(141, 255, 255, 255),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                  ),
                                ),
                              ],
                            )
                    ],
                  )
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
                        tarefa.notas != '' ? tarefa.notas! : 'Nenhuma nota.',
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
    );
  }
}
