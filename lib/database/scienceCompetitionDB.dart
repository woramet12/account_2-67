import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

// คลาสสำหรับข้อมูลการแข่งขัน
class ScienceCompetitionItem {
  final int keyID;
  final String title;
  final DateTime? date;
  final int score;

  ScienceCompetitionItem({
    required this.keyID,
    required this.title,
    required this.date,
    required this.score,
  });

  // สร้าง factory method เพื่อแปลงข้อมูลจาก Map ให้เป็น ScienceCompetitionItem
  factory ScienceCompetitionItem.fromMap(Map<String, dynamic> map, int keyID) {
    return ScienceCompetitionItem(
      keyID: keyID,
      title: map['title'],
      date: DateTime.parse(map['date']),
      score: map['score'],
    );
  }

  // แปลง ScienceCompetitionItem เป็น Map สำหรับการเก็บในฐานข้อมูล
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date?.toIso8601String(),
      'score': score,
    };
  }
}

// คลาสสำหรับการเชื่อมต่อกับฐานข้อมูลและจัดการข้อมูลการแข่งขัน
class ScienceCompetitionDB {
  final String dbName;

  ScienceCompetitionDB({required this.dbName});

  // เปิดฐานข้อมูล
  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  // เพิ่มการแข่งขันใหม่
  Future<int> insertCompetition(ScienceCompetitionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('competitions');
    int keyID = await store.add(db, item.toMap());
    db.close();
    return keyID;
  }

  // โหลดการแข่งขันทั้งหมดจากฐานข้อมูล
  Future<List<ScienceCompetitionItem>> loadAllCompetitions() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('competitions');

    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder('date', false)]));
    
    List<ScienceCompetitionItem> competitions = [];
    for (var record in snapshot) {
      ScienceCompetitionItem item = ScienceCompetitionItem.fromMap(record.value, record.key);
      competitions.add(item);
    }

    db.close();
    return competitions;
  }

  // ลบการแข่งขัน
  Future<void> deleteCompetition(ScienceCompetitionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('competitions');

    await store.delete(
      db,
      finder: Finder(filter: Filter.equals(Field.key, item.keyID)),
    );
    db.close();
  }

  // อัปเดตข้อมูลการแข่งขัน
  Future<void> updateCompetition(ScienceCompetitionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('competitions');

    await store.update(
      db,
      item.toMap(),
      finder: Finder(filter: Filter.equals(Field.key, item.keyID)),
    );

    db.close();
  }
}
