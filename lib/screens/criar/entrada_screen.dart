import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minhas_tarefas/components/input_component.dart';
import 'package:minhas_tarefas/components/notification_snack_bar.dart';
import 'package:minhas_tarefas/controllers/financa_controller.dart';
import 'package:minhas_tarefas/models/financa.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

class EntradaScreen extends StatefulWidget {
  const EntradaScreen({Key? key}) : super(key: key);

  @override
  EntradaScreenState createState() => EntradaScreenState();
}

class EntradaScreenState extends State<EntradaScreen> {
  Rx<DateTime> diaFoco = Rx<DateTime>(DateTime.now());
  final listaRecorrencias = [
    'Mensal',
    'Nunca repetir',
  ];

  RxString recorrenciaSelecionada = 'Nunca repetir'.obs;

  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final notasController = TextEditingController();
  final qtdRecorrenciaController = TextEditingController();

  final financaController = Get.put(FinancaController());

  final financa = Get.arguments['financa'] as Financa?;

  RxBool isEntrada = RxBool(true);
  RxBool temLimite = RxBool(false);

  @override
  void initState() {
    super.initState();
    if (financa != null) {
      String reco = '';
      if (financa!.qtdRecorrencia != null) {
        reco = financa!.qtdRecorrencia.toString();
      }
      diaFoco.value = financa!.dataFinanca;
      descricaoController.text = financa!.descricao ?? '';
      notasController.text = financa!.notas ?? '';
      isEntrada.value = financa!.entrada;
      recorrenciaSelecionada.value = financa!.recorrencia;
      valorController.text = financa!.valor.toString();
      qtdRecorrenciaController.text = reco;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        financa != null
            ? Get.offNamed(
                '/visualizar_financa',
                arguments: {
                  'financa': financa,
                },
              )
            : Get.offNamed(
                '/home_financas',
              );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => financa != null
                ? Get.offNamed(
                    '/visualizar_financa',
                    arguments: {
                      'financa': financa,
                    },
                  )
                : Get.offNamed(
                    '/home_financas',
                  ),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                try {
                  if (valorController.text == '') {
                    NotificationSnackbar.showError(
                        context, 'O campo VALOR precisa ser preenchido.');
                    return;
                  }
                  double valor = double.parse(valorController.text);
                  int? qtdRecorrencia;
                  if (temLimite.isTrue) {
                    qtdRecorrencia = int.parse(qtdRecorrenciaController.text);
                  }
                  Financa novaFinanca = Financa(
                      recorrencia: recorrenciaSelecionada.value,
                      valor: valor,
                      dataFinanca: diaFoco.value,
                      entrada: isEntrada.value,
                      descricao: descricaoController.text,
                      notas: notasController.text,
                      qtdRecorrencia: qtdRecorrencia);

                  if (financa != null) {
                    novaFinanca.id = financa!.id;
                    novaFinanca =
                        await financaController.atualizarFinanca(novaFinanca);
                    Get.offNamed('/visualizar_financa', arguments: {
                      'financa': novaFinanca,
                    });
                  } else {
                    financaController.criarFinanca(novaFinanca);
                    Get.offNamed('/home_financas');
                  }
                } catch (e) {
                  NotificationSnackbar.showError(context,
                      'Ocorreu algum erro. Verifique os campos e tente novamente.');
                  return;
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Obx(
                    () => TableCalendar(
                      firstDay:
                          diaFoco.value.subtract(const Duration(days: 360)),
                      focusedDay: diaFoco.value.add(const Duration(days: 1)),
                      lastDay: diaFoco.value.add(const Duration(days: 360)),
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
                        if (recorrenciaSelecionada.value == 'Dias semana') {
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
                  ),
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
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60.w,
                        child: CustomTextField(
                          hintText: "* Valor R\$",
                          controller: valorController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final validCharacters = RegExp(r'^[0-9,]*$');
                            if (!validCharacters.hasMatch(value!)) {
                              return 'O campo Valor deve conter apenas números e vírgula.';
                            }
                            return null;
                          },
                        ),
                      ),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () => isEntrada.value = true,
                                child: Container(
                                  width: 20.w - 15,
                                  height: 50,
                                  color: isEntrada.isTrue
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.primary,
                                  child: Center(
                                    child: Text(
                                      "Entrada",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => isEntrada.value = false,
                                child: Container(
                                  width: 20.w - 15,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isEntrada.isFalse
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Saída",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
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
                SizedBox(
                  height: 1.h,
                ),
                Obx(
                  () => recorrenciaSelecionada.value != 'Nunca repetir'
                      ? Row(
                          children: [
                            Text(
                              "Limite de recorrência",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Checkbox(
                              value: temLimite.value,
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              onChanged: (bool? newValue) {
                                setState(
                                  () {
                                    temLimite.value = newValue ?? false;
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      : Container(),
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
                              "Quantidade recorrência:",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            SizedBox(
                              height: 50,
                              width: 30.w,
                              child: CustomTextField(
                                hintText: '1',
                                keyboardType: TextInputType.number,
                                controller: qtdRecorrenciaController,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
