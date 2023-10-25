import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:minhas_tarefas/controllers/categoria_controller.dart';
import 'package:minhas_tarefas/controllers/financa_controller.dart';
import 'package:minhas_tarefas/controllers/tarefa_controller.dart';
import 'package:minhas_tarefas/screens/criar/agendar_screen.dart';
import 'package:minhas_tarefas/screens/criar/entrada_screen.dart';
import 'package:minhas_tarefas/screens/home/home_financas_screen.dart';
import 'package:minhas_tarefas/screens/home/home_tarefa_screen.dart';
import 'package:minhas_tarefas/screens/tarefas/tarefas_screen.dart';
import 'package:minhas_tarefas/screens/visualizar/visualizar_financa_screen.dart';
import 'package:minhas_tarefas/screens/visualizar/visualizar_screen.dart';
import 'package:minhas_tarefas/themes/themes.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/date_symbol_data_local.dart';

final tarefaController = Get.put(TarefaController());
final categoriaController = Get.put(CategoriaController());
final financaController = Get.put(FinancaController());

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  tarefaController.carregarTarefas();
  categoriaController.carregarCategorias();
  financaController.carregarFinancas();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  initializeDateFormatting('pt_BR', null).then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'Marca ai',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const HomeTarefaScreen(),
        getPages: [
          GetPage(
            name: '/home_tarefa',
            page: () => const HomeTarefaScreen(),
          ),
          GetPage(
            name: '/home_financas',
            page: () => const HomeFinancasScreen(),
          ),
          GetPage(
            name: '/agendar',
            page: () => const AgendarScreen(),
          ),
          GetPage(
            name: '/entrada',
            page: () => const EntradaScreen(),
          ),
          GetPage(
            name: '/visualizar',
            page: () => const VisualizarScreen(),
          ),
          GetPage(
            name: '/visualizar_financa',
            page: () => const VisualizarFinancaScreen(),
          ),
          GetPage(
            name: '/tarefas',
            page: () => const TarefasScreen(),
          ),
        ],
      );
    });
  }
}
