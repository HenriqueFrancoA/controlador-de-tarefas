import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minhas_tarefas/components/button_bar_component.dart';
import 'package:minhas_tarefas/components/card_financa.dart';
import 'package:minhas_tarefas/components/floating_button_component.dart';
import 'package:minhas_tarefas/controllers/financa_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class HomeFinancasScreen extends StatefulWidget {
  const HomeFinancasScreen({Key? key}) : super(key: key);

  @override
  HomeFinancasScreenState createState() => HomeFinancasScreenState();
}

DateTime hoje = DateTime.now();

final dateFormat = DateFormat('dd MMM yyyy', 'pt_BR');

final List<String> semanasMes = [
  '1º',
  '2ª',
  '3ª',
  '4ª',
  '5ª',
];

final List<String> diasDaSemana = [
  'seg',
  'ter',
  'qua',
  'qui',
  'sex',
  'sáb',
  'dom',
];

final financaController = Get.put(FinancaController());

class HomeFinancasScreenState extends State<HomeFinancasScreen> {
  RxBool graficoSemana = RxBool(true);
  RxInt diaSelecionado = (hoje.weekday - 1).obs;

  @override
  void initState() {
    financaController.filtrarFinancasDoMesAtual();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.all(15),
        child: GetBuilder<FinancaController>(builder: (controller) {
          RxInt semanaSelecionada = controller.verificaSemana(hoje).obs;
          return Column(
            children: [
              Text(
                "FINANÇAS",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: const Color(0xFF333333),
                    ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          graficoSemana.isTrue ? 'Semanal' : 'Diário',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Switch(
                          activeColor: Theme.of(context).colorScheme.primary,
                          inactiveThumbColor:
                              Theme.of(context).colorScheme.primary,
                          value: graficoSemana.value,
                          onChanged: (value) {
                            graficoSemana.value = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: 100.w,
                height: 35.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Obx(
                  () => controller.todasFinancas.isEmpty
                      ? Center(
                          child: Text(
                            'Sem tarefas nessa semana...',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        )
                      : graficoSemana.isTrue
                          ? Card(
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
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
                                            semanasMes[value.toInt()],
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
                                            toY: controller.quantidadeFinancaPorSemana[
                                                        0] <
                                                    0
                                                ? controller.quantidadeFinancaPorSemana[
                                                        0] *
                                                    -1
                                                : controller
                                                    .quantidadeFinancaPorSemana[0],
                                            width: 20,
                                            color:
                                                controller.quantidadeFinancaPorSemana[
                                                            0] <
                                                        0
                                                    ? semanaSelecionada.value ==
                                                            0
                                                        ? Colors.red[800]
                                                        : Colors.red
                                                    : semanaSelecionada.value ==
                                                            0
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
                                            toY: controller.quantidadeFinancaPorSemana[
                                                        1] <
                                                    0
                                                ? controller.quantidadeFinancaPorSemana[
                                                        1] *
                                                    -1
                                                : controller
                                                    .quantidadeFinancaPorSemana[1],
                                            width: 20,
                                            color:
                                                controller.quantidadeFinancaPorSemana[
                                                            1] <
                                                        0
                                                    ? semanaSelecionada.value ==
                                                            1
                                                        ? Colors.red[800]
                                                        : Colors.red
                                                    : semanaSelecionada.value ==
                                                            1
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
                                            toY: controller.quantidadeFinancaPorSemana[
                                                        2] <
                                                    0
                                                ? controller.quantidadeFinancaPorSemana[
                                                        2] *
                                                    -1
                                                : controller
                                                    .quantidadeFinancaPorSemana[2],
                                            width: 20,
                                            color:
                                                controller.quantidadeFinancaPorSemana[
                                                            2] <
                                                        0
                                                    ? semanaSelecionada.value ==
                                                            2
                                                        ? Colors.red[800]
                                                        : Colors.red
                                                    : semanaSelecionada.value ==
                                                            2
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
                                            toY: controller.quantidadeFinancaPorSemana[
                                                        3] <
                                                    0
                                                ? controller.quantidadeFinancaPorSemana[
                                                        3] *
                                                    -1
                                                : controller
                                                    .quantidadeFinancaPorSemana[3],
                                            width: 20,
                                            color:
                                                controller.quantidadeFinancaPorSemana[
                                                            3] <
                                                        0
                                                    ? semanaSelecionada.value ==
                                                            3
                                                        ? Colors.red[800]
                                                        : Colors.red
                                                    : semanaSelecionada.value ==
                                                            3
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
                                            toY: controller.quantidadeFinancaPorSemana[
                                                        4] <
                                                    0
                                                ? controller.quantidadeFinancaPorSemana[
                                                        4] *
                                                    -1
                                                : controller
                                                    .quantidadeFinancaPorSemana[4],
                                            width: 20,
                                            color:
                                                controller.quantidadeFinancaPorSemana[
                                                            4] <
                                                        0
                                                    ? semanaSelecionada.value ==
                                                            4
                                                        ? Colors.red[800]
                                                        : Colors.red
                                                    : semanaSelecionada.value ==
                                                            4
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
                                          String menor = '';
                                          if (rod.color == Colors.red[800]) {
                                            menor = '-';
                                          }
                                          return BarTooltipItem(
                                            'saldo ${semanasMes[group.x.toInt()]} semana: $menor${rod.toY}',
                                            const TextStyle(
                                                color: Colors.white),
                                          );
                                        },
                                      ),
                                      touchCallback: (_, p1) {
                                        if (p1 != null) {
                                          if (p1.spot == null) {
                                            semanaSelecionada.value = -1;
                                          } else {
                                            semanaSelecionada.value =
                                                p1.spot!.touchedBarGroupIndex;
                                            controller
                                                .filtrarFinancasSemanaSelecionada(
                                                    p1.spot!
                                                        .touchedBarGroupIndex);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : PieChart(
                              PieChartData(
                                sections: List<PieChartSectionData>.generate(
                                  7,
                                  (index) {
                                    final dia = diasDaSemana[index];
                                    double quantidadeFinanca = 0;
                                    Color corFatia = Colors.black;
                                    String menos = '';
                                    if (controller
                                            .quantidadeFinancaPorDia[index] <
                                        0) {
                                      quantidadeFinanca = controller
                                              .quantidadeFinancaPorDia[index] *
                                          -1;
                                      menos = '-';
                                      if (diaSelecionado.value == index) {
                                        corFatia = Colors.red[800]!;
                                      } else {
                                        corFatia = Colors.red;
                                      }
                                    } else {
                                      quantidadeFinanca = controller
                                          .quantidadeFinancaPorDia[index];
                                      menos = '';
                                      if (diaSelecionado.value == index) {
                                        corFatia = Theme.of(context)
                                            .colorScheme
                                            .secondary;
                                      } else {
                                        corFatia = Theme.of(context)
                                            .colorScheme
                                            .primary;
                                      }
                                    }

                                    return PieChartSectionData(
                                      color: corFatia,
                                      title:
                                          '$dia\n R\$ $menos$quantidadeFinanca',
                                      titleStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      value: quantidadeFinanca,
                                      radius: 17.h,
                                    );
                                  },
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                pieTouchData: PieTouchData(
                                  enabled: true,
                                  touchCallback: (_, p1) {
                                    if (p1 != null) {
                                      if (p1.touchedSection != null) {
                                        if (p1.touchedSection!.touchedSection !=
                                            null) {
                                          int contador = 0;
                                          for (String dias in diasDaSemana) {
                                            if (p1.touchedSection!
                                                .touchedSection!.title
                                                .contains(dias)) {
                                              diaSelecionado.value = contador;
                                            }
                                            contador++;
                                          }
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                ),
              ),
              SizedBox(height: 2.h),
              Obx(
                () => graficoSemana.isTrue
                    ? FutureBuilder(
                        future: controller.filtrarFinancasSemanaSelecionada(
                            semanaSelecionada.value),
                        builder: (context, snapshot) => Obx(
                          () => SizedBox(
                            height: 36.h,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount: controller.semanaSelecionada.length,
                              itemBuilder: (context, index) {
                                return CardFinanca(
                                  financa: controller.semanaSelecionada[index],
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 1.h,
                              ),
                            ),
                          ),
                        ),
                      )
                    : FutureBuilder(
                        future: controller.filtrarFinancasDiaSelecionado(
                            diaSelecionado.value + 1),
                        builder: (context, snapshot) => Obx(
                          () => SizedBox(
                            height: 36.h,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount: controller.diaSelecionado.length,
                              itemBuilder: (context, index) {
                                return CardFinanca(
                                  financa: controller.diaSelecionado[index],
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 1.h,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 2.h),
              ButtonBarComponent(
                selectedIndex: 1,
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingButtonMenu(
        icons: const [Icons.add],
        nomesBotoes: const ["Adicionar"],
        onPresseds: [
          () {
            Get.toNamed('/entrada', arguments: {
              "tarefa": null,
            });
          },
        ],
      ),
    );
  }
}
