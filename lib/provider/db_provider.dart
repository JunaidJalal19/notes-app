import 'package:flutter/cupertino.dart';

import '../database/local/database_helper.dart';

class DbProvider extends ChangeNotifier {

  DatabaseHelper DbInstance;

  DbProvider({required this.DbInstance});

  List<Map<String,dynamic>> _notesDbData = [];
  Map<String, dynamic> _singleNoteData = {};

  List<Map<String, dynamic>> getNotesData() => _notesDbData;
  Map<String, dynamic> getSingleNoteData() => _singleNoteData;


  ///<><><><><><><> Events <><><><><><><>//

  // initData
  void getInitData() async {
    _notesDbData = await DbInstance.fetchNotes();
    notifyListeners();
  }

  void fetchSingleNote({required int id}) async {
    var result = await DbInstance.fetchSingleNote(id: id);

    if(result != null) {
      _singleNoteData = result;
      notifyListeners();
    }
  }


  // add data
  void addNote({String? title, String? desc}) async {
    bool isDone = await DbInstance.addNote(title: title, desc: desc);

    if(isDone) {
      _notesDbData = await DbInstance.fetchNotes();
      notifyListeners();
    }
  }


  // updates data
  void updateNote({required int id, required String title, required String desc}) async {
    bool isUpdated = await DbInstance.updateNote(id: id, title: title, desc: desc);

    if(isUpdated) {
      _notesDbData = await DbInstance.fetchNotes();
      notifyListeners();
    }
  }





}