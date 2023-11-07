import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minhas_tarefas/components/banner_component.dart';
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
final mesFormat = DateFormat('MMMM yyyy', 'pt_BR');

final List<String> semanasMes = [
  '1ª',
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
  DateTime mesSelecionado = DateTime.now();
  bool isBannerClosed = false;

  @override
  void initState() {
    financaController.filtrarFinancasDoMesAtual(mesSelecionado);
    super.initState();
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
                isBannerClosed
                    ? Container()
                    : BannerComponent(
                        onBannerClosed: () {
                          setState(() {
                            isBannerClosed = true;
                          });
                        },
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
                            mesSelecionado = DateTime(
                              mesSelecionado.year,
                              mesSelecionado.month - 1,
                              mesSelecionado.day,
                            );
                            financaController
                                .filtrarFinancasDoMesAtual(mesSelecionado);
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                        ),
                      ),
                      Text(
                        mesFormat.format(mesSelecionado).toUpperCase(),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: const Color(0xFF333333),
                            ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            mesSelecionado = DateTime(
                              mesSelecionado.year,
                              mesSelecionado.month + 1,
                              mesSelecionado.day,
                            );
                            financaController
                                .filtrarFinancasDoMesAtual(mesSelecionado);
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_right,
                        ),
                      ),
                    ],
                  ),
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
                  height: isBannerClosed ? 35.h : 35.h - 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Obx(
                    () => controller.todasFinancas.isEmpty
                        ? Center(
                            child: Text(
                              'Sem tarefas nesse mês...',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          )
                        : graficoSemana.isTrue
                            ? Column(
                                children: [
                                  SizedBox(
                                    width: 100.w,
                                    height: isBannerClosed ? 29.h : 29.h - 50,
                                    child: Card(
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
                                            gridData:
                                                const FlGridData(show: false),
                                            barGroups: List<
                                                    BarChartGroupData>.generate(
                                                5, (index) {
                                              return BarChartGroupData(
                                                x: index,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: controller.valorFinancaPorSemana[
                                                                index] <
                                                            0
                                                        ? controller.valorFinancaPorSemana[
                                                                index] *
                                                            -1
                                                        : controller
                                                                .valorFinancaPorSemana[
                                                            index],
                                                    fromY: 0,
                                                    width: 20,
                                                    color: controller
                                                                    .valorFinancaPorSemana[
                                                                index] <
                                                            0
                                                        ? semanaSelecionada
                                                                    .value ==
                                                                index
                                                            ? Colors.red[800]
                                                            : Colors.red
                                                        : semanaSelecionada
                                                                    .value ==
                                                                index
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
                                              );
                                            }),
                                            barTouchData: BarTouchData(
                                              touchTooltipData:
                                                  BarTouchTooltipData(
                                                tooltipBgColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                getTooltipItem:
                                                    (group, _, rod, __) {
                                                  return BarTooltipItem(
                                                    'Semana ${semanasMes[group.x.toInt()]}: Valor: ${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(controller.valorFinancaPorSemana[group.x.toInt()])}   Quantidade: ${controller.quantidadeFinancaPorSemana[group.x.toInt()].round()}',
                                                    const TextStyle(
                                                        color: Colors.white),
                                                  );
                                                },
                                              ),
                                              touchCallback: (_, p1) {
                                                if (p1 != null) {
                                                  if (p1.spot == null) {
                                                    semanaSelecionada.value =
                                                        -1;
                                                  } else {
                                                    semanaSelecionada.value = p1
                                                        .spot!
                                                        .touchedBarGroupIndex;
                                                    controller
                                                        .filtrarFinancasSemanaSelecionada(
                                                            p1.spot!
                                                                .touchedBarGroupIndex,
                                                            mesSelecionado);
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  SizedBox(
                                    height: 5.h,
                                    width: 100.w,
                                    child: Card(
                                      elevation: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: List<Widget>.generate(
                                          5,
                                          (index) {
                                            return GestureDetector(
                                              onTap: () => semanaSelecionada
                                                  .value = index,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: semanaSelecionada
                                                                .value ==
                                                            index
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .secondary
                                                        : Colors.transparent),
                                                child: Text(
                                                  "${semanasMes[index]} sem.",
                                                  style:
                                                      semanaSelecionada.value ==
                                                              index
                                                          ? Theme.of(context)
                                                              .textTheme
                                                              .bodySmall
                                                          : Theme.of(context)
                                                              .textTheme
                                                              .labelSmall,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    width: 100.w,
                                    height: isBannerClosed ? 29.h : 29.h - 50,
                                    child: PieChart(
                                      PieChartData(
                                        sections:
                                            List<PieChartSectionData>.generate(
                                          7,
                                          (index) {
                                            final dia = diasDaSemana[index];
                                            double quantidadeFinanca = 0;
                                            Color corFatia = Colors.black;

                                            if (controller
                                                        .quantidadeFinancaPorDia[
                                                    index] <
                                                0) {
                                              quantidadeFinanca = controller
                                                          .quantidadeFinancaPorDia[
                                                      index] *
                                                  -1;

                                              if (diaSelecionado.value ==
                                                  index) {
                                                corFatia = Colors.red[800]!;
                                              } else {
                                                corFatia = Colors.red;
                                              }
                                            } else {
                                              quantidadeFinanca = controller
                                                      .quantidadeFinancaPorDia[
                                                  index];

                                              if (diaSelecionado.value ==
                                                  index) {
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
                                              title: '$dia\n',
                                              titleStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                              value: quantidadeFinanca,
                                              radius: isBannerClosed
                                                  ? 14.5.h
                                                  : 14.5.h - 25,
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
                                                if (p1.touchedSection!
                                                        .touchedSection !=
                                                    null) {
                                                  int contador = 0;
                                                  for (String dias
                                                      in diasDaSemana) {
                                                    if (p1.touchedSection!
                                                        .touchedSection!.title
                                                        .contains(dias)) {
                                                      diaSelecionado.value =
                                                          contador;
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
                                  SizedBox(height: 1.h),
                                  SizedBox(
                                    height: 5.h,
                                    width: 100.w,
                                    child: Card(
                                      elevation: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: List<Widget>.generate(
                                          7,
                                          (index) {
                                            return GestureDetector(
                                              onTap: () =>
                                                  diaSelecionado.value = index,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: diaSelecionado
                                                                .value ==
                                                            index
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .secondary
                                                        : Colors.transparent),
                                                child: Text(
                                                  diasDaSemana[index],
                                                  style: diaSelecionado.value ==
                                                          index
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .labelSmall,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(
                  () => graficoSemana.isTrue
                      ? SizedBox(
                          height: 30.h,
                          child: FutureBuilder(
                            future: controller.filtrarFinancasSemanaSelecionada(
                                semanaSelecionada.value, mesSelecionado),
                            builder: (context, snapshot) => Obx(
                              () => ListView.separated(
                                scrollDirection: Axis.vertical,
                                itemCount: controller.semanaSelecionada.length,
                                itemBuilder: (context, index) {
                                  return CardFinanca(
                                    financa:
                                        controller.semanaSelecionada[index],
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 1.h,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 30.h,
                          child: FutureBuilder(
                            future: controller.filtrarFinancasDiaSelecionado(
                                diaSelecionado.value + 1),
                            builder: (context, snapshot) => Obx(
                              () => ListView.separated(
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
              Get.offNamed('/entrada', arguments: {
                "tarefa": null,
              });
            },
          ],
        ),
      ),
    );
  }
}
