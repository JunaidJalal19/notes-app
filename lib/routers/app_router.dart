import 'package:flutter/material.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/screens/home_screen.dart';
import 'package:note_app/screens/note_screen.dart';

class AppRouter {
  static const home_screen = "/";
  static const notes_screen = "/notes_screen";
  static const add_note_screen = "/add_note";

  // static final Map<String, Widget Function(BuildContext)> routes = {
  //   home_screen: (context) => HomeScreen(),
  //   notes_screen: (context) => NoteScreen(),
  //   add_note_screen: (context) => AddNoteScreen(),
  // };

  static Route<dynamic>? appOnGenerateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case home_screen:
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case notes_screen :
        final value = setting.arguments as int;
        return MaterialPageRoute(builder: (context) => NoteScreen(id: value));


      case add_note_screen :
        final value = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context) => AddNoteScreen(isUpdating: value?["isUpdating"] ?? false, id: value?["id"],));

      default:
        return null;
    }
  }


}
