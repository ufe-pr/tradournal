import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trader_journal/services/TradeModel.dart';
import 'package:trader_journal/services/SnapshotModel.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TradAppDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE trades ("
          "trade_id INTEGER PRIMARY KEY,"
          "symbol TEXT NOT NULL,"
          "volume REAL NOT NULL,"
          "entry_price REAL NOT NULL,"
          "stop_loss REAL,"
          "take_profit REAL,"
          "entry_time TEXT NOT NULL,"
          "direction BOOLEAN NOT NULL,"
          "entry_reason TEXT,"
          "close_time TEXT,"
          "close_price REAL,"
          "trade_management TEXT,"
          "closed BOOLEAN DEFAULT 0"
          ");"
          ""
          "CREATE TABLE snapshots ("
          "snapshot_id INTEGER PRIMARY KEY,"
          "path TEXT NOT NULL,"
          "trade_id INTEGER,"
          "FOREIGN KEY (trade_id)"
          "REFERENCES trades (trade_id)"
          "ON UPDATE CASCADE"
          "ON DELETE CASCADE"
          ");");
    });
  }

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  addTrade(Trade newTrade) async {
    final db = await database;
    var table = await db.rawQuery('SELECT MAX(trade_id)+1 as id FROM trades');
    int id = table.first['id'];

    newTrade.tradeID = id;
    var res = await db.insert(
      'trades',
      newTrade.toMap(),
    );
    return res;
  }

  editTrade(Trade editedTrade) async {
    final db = await database;
    var res = await db.update(
      'trades',
      editedTrade.toMap(),
      where: 'trade_id = ?',
      whereArgs: [
        editedTrade.tradeID,
      ],
    );

    return res;
  }

  deleteTrade(int tradeID) async {
    final db = await database;
    await db.delete('snapshots', where: 'trade_id = ?', whereArgs: [tradeID,],);
    return db.delete('trades', where: 'trade_id = ?', whereArgs: [tradeID,],);
  }

  addSnapshot(Snapshot newSnapshot) async {
    var db = await database;
    var table = await db.rawQuery('SELECT MAX(snapshot_id)+1 as id FROM snapshots');
    int id = table.first['id'];

    newSnapshot.snapshotID = id;
    var res = await db.insert(
      'snapshots',
      newSnapshot.toMap(),
    );
    return res;
  }

  deleteSnapshot(int snapshotID) async {
    var db = await database;
    return db.delete('snapshots', where: 'snapshot_id = ?', whereArgs: [snapshotID,],);
  }

  Future<List<Snapshot>> getTradeSnapshots(int tradeID) async {
    var db = await database;
    var res = await db.query('snapshots', where: 'trade_id = ?', whereArgs: [tradeID,],);
    List<Snapshot> list = res.isNotEmpty ? res.map((i) => Snapshot.fromMap(i)).toList() : <Snapshot>[];
    return list;
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from trades");
  }

  Future<List<Trade>> getAllTrades() async {
    final db = await database;
    var res = await db.query("trades");
    List<Trade> list =
    res.isNotEmpty ? res.map((c) => Trade.fromMap(c)).toList() : [];
    return list;
  }
}
