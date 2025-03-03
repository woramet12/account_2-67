import 'package:flutter/material.dart';
import 'package:account/model/scienceCompetitionItem.dart';
import 'package:account/database/ScienceCompetitionDB.dart';

class ScienceCompetitionProvider extends ChangeNotifier {
  List<ScienceCompetitionItem> _competitions = [];
  final ScienceCompetitionDB _db = ScienceCompetitionDB(dbName: 'science_competitions.db');

  List<ScienceCompetitionItem> get competitions => _competitions;

  ScienceCompetitionProvider() {
    loadCompetitions();
  }

  Future<void> loadCompetitions() async {
    try {
      _competitions = await _db.loadAllCompetitions();
    } catch (e) {
      print('❌ Error loading competitions: $e');
      _competitions = [];
    }
    notifyListeners();
  }

  Future<void> addCompetition(ScienceCompetitionItem item) async {
    try {
      int keyID = await _db.insertCompetition(item);
      _competitions.add(item.copyWith(keyID: keyID));
      notifyListeners();
    } catch (e) {
      print('❌ Error adding competition: $e');
    }
  }

  Future<void> updateCompetition(ScienceCompetitionItem updatedItem) async {
    try {
      await _db.updateCompetition(updatedItem);
      final index = _competitions.indexWhere((item) => item.keyID == updatedItem.keyID);
      if (index != -1) {
        _competitions[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error updating competition: $e');
    }
  }

  Future<void> deleteCompetition(ScienceCompetitionItem item) async {
    try {
      await _db.deleteCompetition(item);
      _competitions.removeWhere((competition) => competition.keyID == item.keyID);
      notifyListeners();
    } catch (e) {
      print('❌ Error deleting competition: $e');
    }
  }
}
