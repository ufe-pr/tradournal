import 'dart:async';

import 'package:trader_journal/services/Database.dart';
import 'package:trader_journal/services/TradeModel.dart';
import 'package:trader_journal/services/SnapshotModel.dart';

class TradesBloc {
  final _tradeController = StreamController<List<Trade>>.broadcast();

  get trades => _tradeController.stream;

  dispose() {
    _tradeController.close();
  }

  getTrades() async {
    _tradeController.sink.add(await DBProvider.db.getAllTrades());
  }

  TradesBloc() {
    getTrades();
  }

  deleteTrade(int id) {
    DBProvider.db.deleteTrade(id);
    getTrades();
  }

  addTrade(Trade trade) {
    DBProvider.db.addTrade(trade);
    getTrades();
  }

  editTrade(Trade editedTrade) {
    DBProvider.db.editTrade(editedTrade);
    getTrades();
  }


}

class SnapshotsBloc {
  final int tradeID;

  final _snapshotController = StreamController<List<Snapshot>>.broadcast();

  SnapshotsBloc(this.tradeID);

  get snapshots => _snapshotController.stream;

  dispose() {
    _snapshotController.close();
  }

  getTradeSnapshots() async {
    _snapshotController.sink.add(await DBProvider.db.getTradeSnapshots(this.tradeID));
  }

  addSnapshot(Snapshot snapshot) {
    snapshot.tradeID = this.tradeID;
    DBProvider.db.addSnapshot(snapshot);
  }

  deleteSnapshot(int id) {
    DBProvider.db.deleteSnapshot(id);
  }

}
