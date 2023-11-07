import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: IntroductionScreen(
        key: introKey,
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).colorScheme.secondary,
          color: Theme.of(context).colorScheme.primary,
          activeSize: const Size(13, 13),
          size: const Size(11, 11),
        ),
        pages: [
          PageViewModel(
            titleWidget: Column(
              children: [
                Text(
                  "Seja bem-vindo",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            bodyWidget: Column(
              children: [
                Text(
                  "Bem-vindo ao seu aplicativo de tarefas e controle financeiro.",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Esta é a porta de entrada para simplificar sua organização diária e financeira. Você pode criar, gerenciar e acompanhar suas tarefas e finanças de forma eficiente.",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ],
            ),
            image: SizedBox(
              height: 30.h,
              child: LottieBuilder.asset(
                "assets/onboarding-01.json",
                fit: BoxFit.contain,
              ),
            ),
          ),
          PageViewModel(
            titleWidget: Column(
              children: [
                Text(
                  "Organize suas Tarefas",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            bodyWidget: Column(
              children: [
                Text(
                  "Crie e gerencie suas tarefas com facilidade.",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Planeje seu dia, semana e mês com tarefas personalizadas. Visualize todas as suas tarefas, filtre por dia da semana e mantenha o controle total da sua agenda.",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ],
            ),
            image: SizedBox(
              height: 30.h,
              child: LottieBuilder.asset(
                "assets/onboarding-02.json",
                fit: BoxFit.contain,
              ),
            ),
          ),
          PageViewModel(
            titleWidget: Column(
              children: [
                Text(
                  "Controle suas Finanças",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            bodyWidget: Column(
              children: [
                Text(
                  "Acompanhe seus gastos e orçamento de forma simples",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Registre suas entradas e saídas financeiras, e veja imediatamente o status do seu orçamento. Utilize gráficos para uma visão clara do seu desempenho financeiro semanal ou diário.",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ],
            ),
            image: SizedBox(
              height: 30.h,
              child: LottieBuilder.asset(
                "assets/onboarding-03.json",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
        onDone: () async {
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setBool('salvarAcesso', true);
          });
          Get.offNamed('/home_tarefa');
        },
        showNextButton: false,
        next: Icon(
          Icons.arrow_forward,
          color: Theme.of(context).colorScheme.secondary,
        ),
        done: Text(
          "Começar",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ),
    );
  }
}
