import 'dart:convert';

Snapshot snapshotFromJson(String str) => Snapshot.fromMap(json.decode(str));

String snapshotToJson(Snapshot data) => json.encode(data.toMap());

class Snapshot {
  int snapshotID;
  String path;
  int tradeID;

  Snapshot({
    this.snapshotID,
    this.path,
    this.tradeID,
  });

  factory Snapshot.fromMap(Map<String, dynamic> json) => Snapshot(
    snapshotID: json["snapshot_id"],
    path: json["path"],
    tradeID: json["trade_id"],
  );

  Map<String, dynamic> toMap() => {
    "snapshot_id": snapshotID,
    "path": path,
    "trade_id": tradeID,
  };
}
