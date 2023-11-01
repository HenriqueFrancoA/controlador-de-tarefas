import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minhas_tarefas/components/card_tarefa.dart';
import 'package:minhas_tarefas/components/input_component.dart';
import 'package:minhas_tarefas/controllers/categoria_controller.dart';
import 'package:minhas_tarefas/controllers/tarefa_controller.dart';
import 'package:minhas_tarefas/models/categoria.dart';
import 'package:sizer/sizer.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({Key? key}) : super(key: key);

  @override
  TarefasScreenState createState() => TarefasScreenState();
}

class TarefasScreenState extends State<TarefasScreen> {
  final listaPrioridades = [
    'Alta',
    'Média',
    'Baixa',
    'Sem prioridade',
    '',
  ];
  final listaRecorrencias = [
    'Todo dia',
    'Dias semana',
    'Nunca repetir',
    '',
  ];

  final categoriaController = Get.put(CategoriaController());

  RxString categoriaSelecionada = ''.obs;
  RxString recorrenciaSelecionada = ''.obs;
  RxString prioridadeSelecionada = ''.obs;

  final tarefaController = Get.put(TarefaController());

  final descricaoController = TextEditingController();

  final dateFormat = DateFormat('dd MMM yyyy', 'pt_BR');

  @override
  void initState() {
    super.initState();
    tarefaController.carregarTodasTarefasFiltradas();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.all(15),
          width: 100.w,
          height: 100.h,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 80.w,
                    child: CustomTextField(
                      hintText: "Pesquisar",
                      controller: descricaoController,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        tarefaController.carregarTarefasFiltradas(
                          descricaoController.text,
                          prioridadeSelecionada.value,
                          recorrenciaSelecionada.value,
                          categoriaSelecionada.value,
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 30.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    child: Obx(
                      () {
                        return DropdownButton<String>(
                          value: prioridadeSelecionada.value,
                          onChanged: (String? prioridade) {
                            prioridadeSelecionada.value = prioridade!;
                          },
                          iconEnabledColor:
                              Theme.of(context).colorScheme.secondary,
                          underline: Container(),
                          items: listaPrioridades
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: SizedBox(
                                width: 20.w,
                                child: Text(value,
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                              ),
                            );
                          }).toList(),
                          style: Theme.of(context).textTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 30.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    child: Obx(
                      () {
                        return DropdownButton<String>(
                          value: recorrenciaSelecionada.value,
                          onChanged: (String? recorrencia) {
                            recorrenciaSelecionada.value = recorrencia!;
                          },
                          iconEnabledColor:
                              Theme.of(context).colorScheme.secondary,
                          underline: Container(),
                          items: listaRecorrencias
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: SizedBox(
                                width: 20.w,
                                child: Text(
                                  value,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                            );
                          }).toList(),
                          style: Theme.of(context).textTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 30.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Obx(
                      () {
                        return DropdownButton<String>(
                          value: categoriaSelecionada.value,
                          onChanged: (String? categoria) {
                            categoriaSelecionada.value = categoria!;
                          },
                          iconEnabledColor:
                              Theme.of(context).colorScheme.secondary,
                          underline: Container(),
                          items: [
                            for (Categoria categoria
                                in categoriaController.todasCategorias)
                              DropdownMenuItem<String>(
                                value: categoria.nome,
                                child: SizedBox(
                                  width: 20.w,
                                  child: Text(
                                    categoria.nome,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ),
                              )
                          ],
                          style: Theme.of(context).textTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              Obx(
                () => Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total: ${tarefaController.tarefasFiltradas.length}",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Obx(
                () => SizedBox(
                  height: 60.h,
                  child: Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: tarefaController.tarefasFiltradas.length,
                      itemBuilder: (context, index) {
                        return CardTarefa(
                          tarefa: tarefaController.tarefasFiltradas[index],
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 1.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
