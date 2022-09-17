import 'package:flutter/material.dart';

class EmployeeDChange extends ChangeNotifier {
  String _docId = "";
  String _date = "";

  void changeData(String docId, String date) {
    _docId = docId;
    _date = date;

    notifyListeners();
  }

  String get getDocId => _docId;
  String get getDate => _date;
}
