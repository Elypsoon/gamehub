import 'package:flutter/material.dart';
import 'package:game_hub/screens/achievements_screen.dart';
import 'package:game_hub/screens/controllers/db_manage.dart';
import 'package:game_hub/screens/controllers/history_controller.dart';
import 'package:game_hub/screens/history_screen.dart';
import 'package:get/get.dart';

//Pantallas
import 'package:game_hub/screens/games_screen.dart';
import 'package:game_hub/screens/home_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.database;

  //Controladores que deben ser inicializados al inicio
  Get.put(HistoryController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MenuPage(),
      debugShowCheckedModeBanner: false,

      //Esto es para las rutas
      getPages: [
        GetPage(name: '/', page: () => const MenuPage()),
        GetPage(name: '/games',page: () => const GamesPage()),
        GetPage(name: '/history', page: () => const HistoryPage()),
        GetPage(name: '/achievements', page: () => const AchievementsPage()),
      ],
    );
  }
}