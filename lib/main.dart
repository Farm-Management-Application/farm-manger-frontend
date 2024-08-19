import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/group_detail_screen.dart';
import 'screens/create_group_screen.dart';
import 'screens/edit_group_screen.dart';
import 'screens/workers/worker_list_screen.dart';
import 'screens/workers/worker_detail_screen.dart';
import 'screens/workers/add_worker_screen.dart';
import 'screens/workers/edit_worker_screen.dart';
import 'screens/illness/illness_list_screen.dart';
import 'screens/illness/add_illness_screen.dart';
import 'screens/illness/edit_illness_screen.dart';
import 'screens/illness/illness_detail_screen.dart';
import 'models/illness.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/detail': (context) => DetailScreen(
          livestockType: (ModalRoute.of(context)!.settings.arguments as Map)['livestockType'],
        ),
        '/groupDetail': (context) => GroupDetailScreen(
          group: (ModalRoute.of(context)!.settings.arguments as Map)['group'],
          livestockType: (ModalRoute.of(context)!.settings.arguments as Map)['livestockType'],
        ),
        '/createGroup': (context) => CreateGroupScreen(
          livestockType: (ModalRoute.of(context)!.settings.arguments as Map)['livestockType'],
        ),
        '/editGroup': (context) => EditGroupScreen(
          group: (ModalRoute.of(context)!.settings.arguments as Map)['group'],
          livestockType: (ModalRoute.of(context)!.settings.arguments as Map)['livestockType'],
        ),
        '/workerList': (context) => WorkerListScreen(),
        '/workerDetail': (context) => WorkerDetailScreen(),
        '/addWorker': (context) => AddWorkerScreen(),
        '/editWorker': (context) => EditWorkerScreen(),
        '/illnessList': (context) => IllnessListScreen(),
        '/addIllness': (context) => AddIllnessScreen(),
        '/editIllness': (context) {
          final illness = ModalRoute.of(context)!.settings.arguments as Illness;
          return EditIllnessScreen(illness: illness);
        },
        '/illnessDetail': (context) {
          final illness = ModalRoute.of(context)!.settings.arguments as Illness;
          return IllnessDetailScreen(illness: illness);
        },
      },
    );
  }
}