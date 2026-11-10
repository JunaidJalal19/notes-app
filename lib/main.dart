import 'package:flutter/material.dart';
import 'package:note_app/database/local/database_helper.dart';
import 'package:note_app/provider/db_provider.dart';
import 'package:note_app/routers/app_router.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/screens/home_screen.dart';
import 'package:note_app/screens/note_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DbProvider(DbInstance: DatabaseHelper.instance),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note-App',
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.white.withValues(alpha: 0.4),
          selectionHandleColor: Colors.white,
        ),
      ),
      initialRoute: AppRouter.home_screen,
      onGenerateRoute: (setting) => AppRouter.appOnGenerateRoutes(setting),

    );
  }
}

