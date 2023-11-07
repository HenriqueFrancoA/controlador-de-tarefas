import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minhas_tarefas/components/input_component.dart';
import 'package:minhas_tarefas/components/notification_snack_bar.dart';
import 'package:minhas_tarefas/controllers/categoria_controller.dart';
import 'package:minhas_tarefas/controllers/tarefa_controller.dart';
import 'package:minhas_tarefas/models/categoria.dart';
import 'package:minhas_tarefas/models/tarefa.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendarScreen extends StatefulWidget {
  const AgendarScreen({Key? key}) : super(key: key);

  @override
  AgendarScreenState createState() => AgendarScreenState();
}

class AgendarScreenState extends State<AgendarScreen> {
  Rx<DateTime> diaFoco = Rx<DateTime>(DateTime.now());
  final listaPrioridades = [
    'Alta',
    'Média',
    'Baixa',
    'Sem prioridade',
  ];
  final listaRecorrencias = [
    'Todo dia',
    'Dias semana',
    'Nunca repetir',
  ];

  RxString categoriaSelecionada = ''.obs;
  RxString prioridadeSelecionada = 'Sem prioridade'.obs;
  RxString recorrenciaSelecionada = 'Nunca repetir'.obs;

  final RxString horaSelecionadaComeco = "00".obs;
  final RxString minutoSelecionadoComeco = "00".obs;
  final RxString horaSelecionadaFim = "00".obs;
  final RxString minutoSelecionadoFim = "00".obs;

  final descricaoController = TextEditingController();
  final notasController = TextEditingController();
  final categoriaNomeController = TextEditingController();

  final tarefaController = Get.put(TarefaController());
  final categoriaController = Get.put(CategoriaController());

  List<String> horas =
      List.generate(24, (index) => index.toString().padLeft(2, '0'));

  List<String> minutos =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));

  RxBool temLimite = RxBool(false);

  RxBool desativado = RxBool(false);

  final tarefa = Get.arguments['tarefa'] as Tarefa?;

  @override
  void initState() {
    super.initState();
    if (tarefa != null) {
      if (tarefa!.dataTarefa != null) {
        diaFoco.value = tarefa!.dataTarefa!;
      }
      descricaoController.text = tarefa!.descricao ?? '';
      notasController.text = tarefa!.notas ?? '';
      prioridadeSelecionada.value = tarefa!.prioridade;
      recorrenciaSelecionada.value = tarefa!.recorrencia;
      desativado.value = tarefa!.desativado;
      if (tarefa!.categoria != null) {
        categoriaSelecionada.value = tarefa!.categoria!.nome;
      }
      horaSelecionadaComeco.value = tarefa!.horarioInicio.substring(0, 2);
      minutoSelecionadoComeco.value = tarefa!.horarioInicio.substring(3, 5);
      if (tarefa!.horarioFim != null) {
        temLimite = RxBool(true);
        horaSelecionadaFim.value = tarefa!.horarioFim!.substring(0, 2);
        minutoSelecionadoFim.value = tarefa!.horarioFim!.substring(3, 5);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        tarefa != null
            ? Get.offNamed('/visualizar', arguments: {
                'tarefa': tarefa,
              })
            : Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => tarefa != null
                ? Get.offNamed('/visualizar', arguments: {
                    'tarefa': tarefa,
                  })
                : Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                String horarioInicio =
                    "${horaSelecionadaComeco.value}:${minutoSelecionadoComeco.value}";
                String? horarioFim;
                if (temLimite.isTrue) {
                  horarioFim =
                      "${horaSelecionadaFim.value}:${minutoSelecionadoFim.value}";
                }
                try {
                  Tarefa novaTarefa = Tarefa(
                    descricao: descricaoController.text,
                    notas: notasController.text,
                    dataTarefa: recorrenciaSelecionada.value == 'Nunca repetir'
                        ? diaFoco.value
                        : null,
                    horarioInicio: horarioInicio,
                    horarioFim: horarioFim,
                    recorrencia: recorrenciaSelecionada.value,
                    prioridade: prioridadeSelecionada.value,
                    desativado: desativado.value,
                  );

                  if (tarefa != null) {
                    novaTarefa.id = tarefa!.id;

                    novaTarefa = await tarefaController.atualizarTarefa(
                        novaTarefa, categoriaSelecionada.value);

                    Get.offNamed('/visualizar', arguments: {
                      'tarefa': novaTarefa,
                    });
                  } else {
                    await tarefaController.criarTarefa(
                        novaTarefa, categoriaSelecionada.value);
                    Get.back();
                  }
                } catch (e) {
                  NotificationSnackbar.showError(context,
                      'Ocorreu algum erro. Verifique os campos e tente novamente.');
                }
              },
              child: Text(
                "Salvar",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.all(15),
          width: 100.w,
          height: 100.h,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => recorrenciaSelecionada.value == 'Nunca repetir'
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TableCalendar(
                            firstDay: diaFoco.value
                                .subtract(const Duration(days: 360)),
                            focusedDay:
                                diaFoco.value.add(const Duration(days: 1)),
                            lastDay:
                                diaFoco.value.add(const Duration(days: 360)),
                            locale: 'pt_BR',
                            headerStyle: HeaderStyle(
                              titleTextStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              titleCentered: true,
                              formatButtonVisible: false,
                              leftChevronIcon: Icon(
                                Icons.chevron_left,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              rightChevronIcon: Icon(
                                Icons.chevron_right,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            daysOfWeekStyle: const DaysOfWeekStyle(
                              weekdayStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              weekendStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            rowHeight: 35,
                            calendarStyle: CalendarStyle(
                              cellPadding: const EdgeInsets.all(0),
                              cellMargin: const EdgeInsets.all(0),
                              defaultTextStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                              weekendTextStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              todayDecoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              todayTextStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            selectedDayPredicate: (day) {
                              return isSameDay(diaFoco.value, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              if (recorrenciaSelecionada.value ==
                                  'Dias semana') {
                                if (selectedDay.weekday == 6 ||
                                    selectedDay.weekday == 7) {
                                  selectedDay =
                                      selectedDay.add(const Duration(days: 2));
                                }
                                diaFoco.value = selectedDay;
                              } else {
                                diaFoco.value = selectedDay;
                              }
                            },
                          ),
                        )
                      : Container(),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  height: 50,
                  child: CustomTextField(
                    hintText: "Descrição",
                    controller: descricaoController,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    controller: notasController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'Escreva suas notas aqui...',
                      hintStyle:
                          Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Prioridade:",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
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
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categoria:",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Row(
                      children: [
                        Container(
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
                                      child: Text(categoria.nome),
                                    )
                                ],
                                style: Theme.of(context).textTheme.labelSmall,
                              );
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Criar categoria",
                              titleStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              content: Container(
                                width: 100.w,
                                height: 20.h,
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomTextField(
                                      hintText: "Nome da categoria",
                                      controller: categoriaNomeController,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          if (categoriaNomeController.text !=
                                              '') {
                                            Categoria novaCategoria = Categoria(
                                              nome:
                                                  categoriaNomeController.text,
                                            );
                                            await categoriaController
                                                .criarCategoria(novaCategoria);
                                            categoriaNomeController.text = '';
                                            Get.back();
                                          } else {
                                            NotificationSnackbar.showError(
                                                context,
                                                'Preencha o nome da categoria.');
                                          }
                                        } catch (e) {
                                          NotificationSnackbar.showError(
                                              context,
                                              'Ocorreu algum erro. Verifique os campos e tente novamente.');
                                        }
                                      },
                                      child: Text(
                                        'Criar',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selecione o horario: ",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Obx(
                            () {
                              return DropdownButton<String>(
                                value: horaSelecionadaComeco.value,
                                onChanged: (String? value) {
                                  horaSelecionadaComeco.value = value!;
                                },
                                iconEnabledColor:
                                    Theme.of(context).colorScheme.secondary,
                                underline: Container(),
                                items: horas.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                style: Theme.of(context).textTheme.labelSmall,
                              );
                            },
                          ),
                        ),
                        Text(
                          " : ",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Obx(
                            () {
                              return DropdownButton<String>(
                                value: minutoSelecionadoComeco.value,
                                onChanged: (String? value) {
                                  minutoSelecionadoComeco.value = value!;
                                },
                                iconEnabledColor:
                                    Theme.of(context).colorScheme.secondary,
                                underline: Container(),
                                items: minutos.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                style: Theme.of(context).textTheme.labelSmall,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    Text(
                      "Limite de horário",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Checkbox(
                      value: temLimite.value,
                      activeColor: Theme.of(context).colorScheme.secondary,
                      onChanged: (bool? newValue) {
                        setState(
                          () {
                            temLimite.value = newValue ?? false;
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Obx(
                  () => temLimite.isTrue
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Selecione o horario limite: ",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Obx(
                                    () {
                                      return DropdownButton<String>(
                                        value: horaSelecionadaFim.value,
                                        onChanged: (String? value) {
                                          horaSelecionadaFim.value = value!;
                                        },
                                        iconEnabledColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        underline: Container(),
                                        items: horas
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  " : ",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Obx(
                                    () {
                                      return DropdownButton<String>(
                                        value: minutoSelecionadoFim.value,
                                        onChanged: (String? value) {
                                          minutoSelecionadoFim.value = value!;
                                        },
                                        iconEnabledColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        underline: Container(),
                                        items: minutos
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recorrência:",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Obx(
                        () {
                          return DropdownButton<String>(
                            value: recorrenciaSelecionada.value,
                            onChanged: (String? recorrencia) {
                              recorrenciaSelecionada.value = recorrencia!;

                              if (recorrenciaSelecionada.value ==
                                  'Dias semana') {
                                if (diaFoco.value.weekday == 6 ||
                                    diaFoco.value.weekday == 7) {
                                  diaFoco.value = diaFoco.value
                                      .add(const Duration(days: 2));
                                }
                              }
                            },
                            iconEnabledColor:
                                Theme.of(context).colorScheme.secondary,
                            underline: Container(),
                            items: listaRecorrencias
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                tarefa != null
                    ? Column(
                        children: [
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Text(
                                "Desativar",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Checkbox(
                                value: desativado.value,
                                activeColor: Colors.red,
                                onChanged: (bool? newValue) {
                                  setState(
                                    () {
                                      desativado.value = newValue ?? false;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
