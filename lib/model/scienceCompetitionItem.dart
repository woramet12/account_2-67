import 'package:flutter/material.dart';

class ScienceCompetitionItem {
  final int keyID;        // รหัสการแข่งขัน (ใช้สำหรับการระบุรายการ)
  final String title;     // ชื่อการแข่งขัน
  final DateTime? date;   // วันที่ของการแข่งขัน
  final int score;        // คะแนนของการแข่งขัน
  final TimeOfDay? time;  // เวลาแข่งขัน (ใหม่)
  final String? description; // รายละเอียดเพิ่มเติม

  // Constructor
  ScienceCompetitionItem({
    required this.keyID,
    required this.title,
    required this.date,
    required this.score,
    this.time,  // เพิ่มเวลาเป็นตัวเลือก
    this.description, // เพิ่มฟิลด์สำหรับรายละเอียดการแข่งขัน
  });

  // แปลง ScienceCompetitionItem เป็น Map สำหรับการเก็บในฐานข้อมูล
  Map<String, dynamic> toMap() {
    // หากมีเวลาให้แปลง TimeOfDay เป็น DateTime
    DateTime? dateTimeWithTime;
    if (time != null && date != null) {
      dateTimeWithTime = DateTime(date!.year, date!.month, date!.day, time!.hour, time!.minute);
    }

    return {
      'keyID': keyID,
      'title': title,
      'date': date?.toIso8601String(),
      'score': score,
      'time': dateTimeWithTime?.toIso8601String(), // เก็บเวลาเป็น DateTime
      'description': description, // เพิ่มฟิลด์สำหรับรายละเอียดการแข่งขัน
    };
  }

  // แปลงจาก Map กลับมาเป็น ScienceCompetitionItem
  factory ScienceCompetitionItem.fromMap(Map<String, dynamic> map, int keyID) {
    DateTime? dateTime;
    if (map['time'] != null) {
      dateTime = DateTime.parse(map['time']);
    }

    return ScienceCompetitionItem(
      keyID: keyID,
      title: map['title'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      score: map['score'],
      time: dateTime != null ? TimeOfDay(hour: dateTime.hour, minute: dateTime.minute) : null, // แปลงกลับเป็น TimeOfDay
      description: map['description'], // เพิ่มฟิลด์สำหรับรายละเอียดการแข่งขัน
    );
  }

  // คัดลอกข้อมูลและเปลี่ยนแปลงบางค่าของอ็อบเจ็กต์
  ScienceCompetitionItem copyWith({
    int? keyID,
    String? title,
    DateTime? date,
    int? score,
    TimeOfDay? time,
    String? description, // เพิ่มฟิลด์สำหรับรายละเอียดการแข่งขัน
  }) {
    return ScienceCompetitionItem(
      keyID: keyID ?? this.keyID,
      title: title ?? this.title,
      date: date ?? this.date,
      score: score ?? this.score,
      time: time ?? this.time,
      description: description ?? this.description, // เพิ่มฟิลด์สำหรับรายละเอียดการแข่งขัน
    );
  }
}
