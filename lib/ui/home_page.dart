import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trader_journal/services/fetch_entries.dart';
import 'package:trader_journal/BLoCs/DatabaseBloc.dart';
import 'package:trader_journal/services/TradeModel.dart';
import 'package:trader_journal/services/SnapshotModel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bloc = TradesBloc();
  Map response;

  getData(data) {
    response = groupEntriesByDate(data);
  }

  Widget listViewBuilder(context, index) {
    String date;
    List<Trade> trades;

    List days = List.from(response.keys);
    days.sort();
    days = List.from(days.reversed);

    date = days[index];
    trades = response[date];

    return Day(
      date: date,
      trades: trades,
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> navigationBarItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('')),
      BottomNavigationBarItem(icon: Icon(Icons.note), title: Text('')),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Firstname Lastname',
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/dp.jpg'),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<Trade>>(
        stream: bloc.trades,
        builder: (BuildContext context, AsyncSnapshot<List<Trade>> snapshot) {
          if (snapshot.hasData) {
            getData(snapshot.data);
            return ListView.builder(
              itemBuilder: listViewBuilder,
              itemCount: response.length,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'add-edit-trade', arguments: {
            'isEdit': false,
            'bloc': bloc,
          });
        },
        child: Container(
          child: Icon(Icons.add),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(items: navigationBarItems),
    );
  }
}

class TradeWidget extends StatefulWidget {
  final Trade trade;

  const TradeWidget({
    Key key,
    this.trade,
  }) : super(key: key);

  @override
  _TradeWidgetState createState() => _TradeWidgetState();
}

class _TradeWidgetState extends State<TradeWidget> {
  SnapshotsBloc bloc;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = SnapshotsBloc(widget.trade.tradeID);
    _expanded = false;
//    screenshots = this.widget.trade.screenshots;
    expandedItems = Column(
      children: <Widget>[
        Divider(),
        Row(
          children: <Widget>[
            Expanded(
                child: Text('Entry price: ${this.widget.trade.entryPrice}')),
            Expanded(child: Text('SL: ${this.widget.trade.sl}')),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(3),
        ),
        Row(
          children: <Widget>[
            Expanded(child: Text('Direction: ${this.widget.trade.direction}')),
            Expanded(child: Text('TP: ${this.widget.trade.tp}')),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Entry reason: ',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(text: this.widget.trade.entryReason),
            ],
          ),
          softWrap: true,
        ),
        Padding(
          padding: EdgeInsets.all(5),
        ),
        Text(
          this.widget.trade.tradeManagement,
          softWrap: true,
        ),
        Padding(
          padding: EdgeInsets.all(3),
        ),
        this.widget.trade.closed
            ? Text(
                'Closed ---> ${this.widget.trade.closePrice} - ${this.widget.trade.closeTime}',
              )
            : Container(),
        Container(
          child: StreamBuilder<List<Snapshot>>(
              stream: bloc.snapshots,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Snapshot>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return index == snapshot.data.length
                          ? InkWell(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 40,
                              ),
                            )
                          : InkWell(
                              child: Container(
                                child:
                                    Image.file(File(snapshot.data[index].path)),
                                height: 50,
                                width: 50,
                                padding: EdgeInsets.all(8),
                              ),
                            );
                    },
                    itemCount: snapshot.data.length + 1,
                    scrollDirection: Axis.horizontal,
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          height: 60,
        ),
        Divider(),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  bool _expanded;
  Widget expandedItems;
//  List<String> screenshots;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    this.widget.trade.symbol,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Text(
                    this.widget.trade.volume.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      this.widget.trade.profit == 0
                          ? '_'
                          : this.widget.trade.profit.toString(),
                      style: TextStyle(
                        color: this.widget.trade.profit == 0
                            ? Colors.black87
                            : Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: this.widget.trade.profit == 0
                            ? Colors.white
                            : this.widget.trade.profit > 0
                                ? Colors.blue
                                : Colors.red,
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20))),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                this.widget.trade.closed
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: Text(
                        this.widget.trade.time,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _expanded ? expandedItems : Container(),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 10,
              spreadRadius: 5,
              color: Colors.black12,
            ),
          ],
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
      ),
      onTap: () {
        setState(() {
          _expanded = !(_expanded);
        });
      },
    );
  }
}

class Day extends StatelessWidget {
  final String date;
  final List<Trade> trades;

  const Day({Key key, this.date, this.trades}) : super(key: key);

  String getDayRep(String date) {
    String rep;

    DateTime formattedDate = DateTime.parse(date);

    Duration timeDifference = DateTime.now().difference(formattedDate);

    rep = timeDifference.inHours < 24
        ? 'Today'
        : ((timeDifference.inHours >= 24) && (timeDifference.inHours < 48))
            ? 'Yesterday'
            : date;

    return rep;
  }

  List<Widget> dayBuilder({String date, List<Trade> dayTrades}) {
    List<Widget> column = <Widget>[
      Text(
        getDayRep(date),
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    ];

    for (int i = 0; i < dayTrades.length; i++) {
      Trade trade = dayTrades[i];
      column.add(Padding(
        padding: EdgeInsets.all(10),
      ));
      column.add(TradeWidget(
        trade: trade,
      ));
    }

    return column;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: dayBuilder(date: this.date, dayTrades: this.trades),
      ),
    );
  }
}
