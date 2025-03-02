import 'package:flutter/material.dart';
import 'package:account/model/scienceCompetitionItem.dart';

class ScienceCompetitionProvider extends ChangeNotifier {
  // รายการของการแข่งขัน
  List<ScienceCompetitionItem> _competitions = [];

  // ดึงข้อมูลการแข่งขันทั้งหมด
  List<ScienceCompetitionItem> get competitions => _competitions;

  // เพิ่มการแข่งขันใหม่
  void addCompetition(ScienceCompetitionItem item) {
    _competitions.add(item);
    notifyListeners();  // แจ้งให้ UI ทราบว่าเกิดการเปลี่ยนแปลง
  }

  // อัปเดตข้อมูลการแข่งขัน
  void updateCompetition(ScienceCompetitionItem updatedItem) {
    final index = _competitions.indexWhere((item) => item.keyID == updatedItem.keyID);
    if (index != -1) {
      _competitions[index] = updatedItem;
      notifyListeners();
    }
  }

  // ลบการแข่งขัน
  void deleteCompetition(ScienceCompetitionItem item) {
    _competitions.removeWhere((competition) => competition.keyID == item.keyID);
    notifyListeners();
  }
}
