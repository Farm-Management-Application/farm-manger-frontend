import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/group_detail_screen.dart';
import 'screens/create_group_screen.dart';
import 'screens/edit_group_screen.dart';

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
      },
    );
  }
}