import 'package:trader_journal/services/TradeModel.dart';

Map groupEntriesByDate(List<Trade> trades) {
  Map days = {};

  for (int i = 0; i < trades.length; i++) {
    Trade trade = trades[i];

    if (days.containsKey(trade.date)) {
      days[trade.date].add(trade);
    } else {
      days[trade.date] = <Trade>[trade,];
    }
  }

  return days;
}
