import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minhas_tarefas/components/button_bar_component.dart';
import 'package:minhas_tarefas/components/card_tarefa.dart';
import 'package:minhas_tarefas/components/floating_button_component.dart';
import 'package:minhas_tarefas/controllers/tarefa_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class HomeTarefaScreen extends StatefulWidget {
  const HomeTarefaScreen({Key? key}) : super(key: key);

  @override
  HomeTarefaScreenState createState() => HomeTarefaScreenState();
}

DateTime hoje = DateTime.now();

final dateFormat = DateFormat('dd MMM yyyy', 'pt_BR');
final mesFormat = DateFormat('MMM yyyy', 'pt_BR');

final List<String> diasDaSemana = [
  'seg',
  'ter',
  'qua',
  'qui',
  'sex',
  'sáb',
  'dom',
];

RxInt diaSelecionado = (hoje.weekday - 1).obs;

class HomeTarefaScreenState extends State<HomeTarefaScreen> {
  DateTime semanaSelecionada = DateTime.now();
  DateTime? firstDayOfWeek;
  DateTime? lastDayOfWeek;

  @override
  void initState() {
    super.initState();

    firstDayOfWeek = semanaSelecionada
        .subtract(Duration(days: semanaSelecionada.weekday - 1));
    lastDayOfWeek = firstDayOfWeek!.add(const Duration(days: 6));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.all(15),
          child: GetBuilder<TarefaController>(builder: (controller) {
            controller.quantidadeTarefa = RxList<int>.filled(7, 0);
            return Column(
              children: [
                Text(
                  "TAREFAS",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color(0xFF333333),
                      ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  width: 100.w,
                  height: 6.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            semanaSelecionada = DateTime(
                              semanaSelecionada.year,
                              semanaSelecionada.month,
                              semanaSelecionada.day - 7,
                            );
                            firstDayOfWeek = semanaSelecionada.subtract(
                                Duration(days: semanaSelecionada.weekday - 1));
                            lastDayOfWeek =
                                firstDayOfWeek!.add(const Duration(days: 6));
                            controller
                                .filtrarTarefasDaSemanaAtual(semanaSelecionada);
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                        ),
                      ),
                      Text(
                        '${firstDayOfWeek!.day} -  ${lastDayOfWeek!.day} ${mesFormat.format(lastDayOfWeek!).toUpperCase()}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: const Color(0xFF333333),
                            ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            semanaSelecionada = DateTime(
                              semanaSelecionada.year,
                              semanaSelecionada.month,
                              semanaSelecionada.day + 7,
                            );
                            firstDayOfWeek = semanaSelecionada.subtract(
                                Duration(days: semanaSelecionada.weekday - 1));
                            lastDayOfWeek =
                                firstDayOfWeek!.add(const Duration(days: 6));
                            controller
                                .filtrarTarefasDaSemanaAtual(semanaSelecionada);
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_right,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Obx(
                    () => controller.estaSemana.isEmpty
                        ? Center(
                            child: Text(
                              'Sem tarefas nessa semana...'.toUpperCase(),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Card(
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: BarChart(
                                  BarChartData(
                                    titlesData: FlTitlesData(
                                      show: true,
                                      leftTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            diasDaSemana[value.toInt()],
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          );
                                        },
                                      )),
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    gridData: const FlGridData(show: false),
                                    barGroups: [
                                      BarChartGroupData(
                                        x: 0,
                                        barRods: [
                                          BarChartRodData(
                                            toY: controller.quantidadeTarefa[0]
                                                .toDouble(),
                                            width: 20,
                                            color: diaSelecionado.value == 0
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 1,
                                        barRods: [
                                          BarChartRodData(
                                            toY: controller.quantidadeTarefa[1]
                                                .toDouble(),
                                            width: 20,
                                            color: diaSelecionado.value == 1
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 2,
                                        barRods: [
                                          BarChartRodData(
                                            toY: controller.quantidadeTarefa[2]
                                                .toDouble(),
                                            width: 20,
                                            color: diaSelecionado.value == 2
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 3,
                                        barRods: [
                                          BarChartRodData(
                                            toY: controller.quantidadeTarefa[3]
                                                .toDouble(),
                                            width: 20,
                                            color: diaSelecionado.value == 3
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 4,
                                        barRods: [
                                          BarChartRodData(
                                            toY: controller.quantidadeTarefa[4]
                                                .toDouble(),
                                            width: 20,
                                            color: diaSelecionado.value == 4
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 5,
                                        barRods: [
                                          BarChartRodData(
                                            toY: controller.quantidadeTarefa[5]
                                                .toDouble(),
                                            width: 20,
                                            color: diaSelecionado.value == 5
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 6,
                                        barRods: [
                                          BarChartRodData(
                                            toY: controller.quantidadeTarefa[6]
                                                .toDouble(),
                                            width: 20,
                                            color: diaSelecionado.value == 6
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                        ],
                                      ),
                                    ],
                                    barTouchData: BarTouchData(
                                        touchTooltipData: BarTouchTooltipData(
                                          tooltipBgColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          getTooltipItem: (group, _, rod, __) {
                                            return BarTooltipItem(
                                              '${diasDaSemana[group.x.toInt()]}: ${rod.toY.toInt()}',
                                              const TextStyle(
                                                  color: Colors.white),
                                            );
                                          },
                                        ),
                                        touchCallback: (_, p1) {
                                          if (p1 != null) {
                                            if (p1.spot == null) {
                                              diaSelecionado.value = -1;
                                            } else {
                                              diaSelecionado.value =
                                                  p1.spot!.touchedBarGroupIndex;
                                              controller
                                                  .filtrarTarefasDiaSelecionado(
                                                      diaSelecionado.value + 1);
                                            }
                                          }
                                        }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 36.h,
                  child: FutureBuilder(
                    future: controller
                        .filtrarTarefasDaSemanaAtual(semanaSelecionada),
                    builder: (context, snapshot) => Obx(
                      () => ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemCount: controller.diaSelecionado.length,
                        itemBuilder: (context, index) {
                          return CardTarefa(
                            tarefa: controller.diaSelecionado[index],
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: 1.h,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                ButtonBarComponent(
                  selectedIndex: 0,
                ),
              ],
            );
          }),
        ),
        floatingActionButton: FloatingButtonMenu(
          icons: const [Icons.add, Icons.list],
          nomesBotoes: const ["Adicionar", "Visualizar"],
          onPresseds: [
            () {
              Get.toNamed('/agendar', arguments: {
                "tarefa": null,
              });
            },
            () {
              Get.toNamed('/tarefas');
            },
          ],
        ),
      ),
    );
  }
}
