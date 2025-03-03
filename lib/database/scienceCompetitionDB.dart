import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/model/scienceCompetitionItem.dart';

class ScienceCompetitionDB {
  final String dbName;

  ScienceCompetitionDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertCompetition(ScienceCompetitionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('competitions');
    int keyID = await store.add(db, item.toMap());
    db.close();
    return keyID;
  }

  Future<List<ScienceCompetitionItem>> loadAllCompetitions() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('competitions');

    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder('date', false)]));

    List<ScienceCompetitionItem> competitions = snapshot.map((record) {
      return ScienceCompetitionItem.fromMap(record.value, record.key);
    }).toList();

    db.close();
    return competitions;
  }

  Future<void> deleteCompetition(ScienceCompetitionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('competitions');

    await store.delete(
      db,
      finder: Finder(filter: Filter.equals(Field.key, item.keyID)),
    );
    db.close();
  }

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
