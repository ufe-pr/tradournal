import 'dart:convert';
import 'package:intl/intl.dart';

Trade tradeFromJson(String str) => Trade.fromMap(json.decode(str));

String tradeToJson(Trade data) => json.encode(data.toMap());

class Trade {
  String symbol, direction, entryReason, tradeManagement;
  int tradeID;
  double volume, entryPrice, sl, tp, closePrice;
  bool closed;
  DateTime entryTime, closeTime;

  Trade(
      {this.tradeID,
      this.symbol = '',
      this.direction = 'long',
      this.entryPrice,
      this.volume,
      this.entryTime,
      this.sl,
      this.tp,
      this.entryReason,
      this.tradeManagement = '',
      this.closePrice,
      this.closeTime,
      this.closed = false});


  get date => DateFormat('yyyy-MM-dd').format(entryTime);
  get profit => closed ? (closePrice - entryPrice) * volume / 1000 : '-';
  get time => DateFormat.Hm().format(entryTime);

  factory Trade.fromMap(Map<String, dynamic> json) {
    int tradeID = json['trade_id'];
    String symbol = json['symbol'];
    String direction = json['direction'] == 0 ? 'short' : 'long';
    double entryPrice = json['entry_price'];
    double volume = json['volume'];
    DateTime entryTime = DateTime.parse(json['entry_time']);
    double sl = json['stop_loss'];
    double tp = json['take_profit'];
    String entryReason = json['entry_reason'];
    String tradeManagement = json['trade_management'];
    double closePrice = json['close_price'];
    DateTime closeTime = DateTime.parse(json['close_time']);
    bool closed = !(json['closed'] == 0);

    return Trade(
        tradeID: tradeID,
        symbol: symbol,
        direction: direction,
        entryPrice: entryPrice,
        volume: volume,
        entryTime: entryTime,
        sl: sl,
        tp: tp,
        entryReason: entryReason,
        tradeManagement: tradeManagement,
        closePrice: closePrice,
        closeTime: closeTime,
        closed: closed);
  }

  Map<String, dynamic> toMap() => {
        'trade_id': tradeID,
        'symbol': symbol,
        'direction': direction == 'short' ? 0 : 1,
        'entry_price': entryPrice,
        'volume': volume,
        'entry_time': entryTime.toString(),
        'stop_loss': sl,
        'take_profit': tp,
        'entry_reason': entryReason,
        'trade_management': tradeManagement,
        'close_price': closePrice,
        'close_time': closeTime.toString(),
        'closed': !closed ? 0 : 1,
      };
}
