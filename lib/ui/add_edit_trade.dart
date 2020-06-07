import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trader_journal/services/TradeModel.dart';
import 'package:trader_journal/BLoCs/DatabaseBloc.dart';

class AddEditTrade extends StatefulWidget {
  @override
  _AddEditTradeState createState() => _AddEditTradeState();
}

class _AddEditTradeState extends State<AddEditTrade> {
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    bool isEdit = data['isEdit'];
    Trade trade = data.containsKey('trade') ? data['trade'] : Trade();
    TradesBloc bloc = data['bloc'];
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit trade - ${trade.symbol}' : 'Add Trade'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        children: <Widget>[
          TradeCreationForm(
            trade: trade,
            bloc: bloc,
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}

class TradeCreationForm extends StatefulWidget {
  final Trade trade;
  final TradesBloc bloc;

  const TradeCreationForm({Key key, this.trade, this.bloc}) : super(key: key);

  @override
  _TradeCreationFormState createState() => _TradeCreationFormState();
}

class _TradeCreationFormState extends State<TradeCreationForm> {
  final GlobalKey _formKey = GlobalKey(debugLabel: 'Trade creation form');

  TextEditingController _symbol,
      _entryReason,
      _tradeManagement,
      _volume,
      _sl,
      _tp,
      _entryPrice,
      _closePrice;

  @override
  void initState() {
    super.initState();
    _symbol = TextEditingController(text: widget.trade.symbol);
    _entryReason = TextEditingController(text: widget.trade.entryReason);
    _tradeManagement =
        TextEditingController(text: widget.trade.tradeManagement);
    _volume = TextEditingController(
        text: widget.trade.volume == null
            ? null
            : widget.trade.volume.toString());
    _sl = TextEditingController(
        text: widget.trade.sl == null ? null : widget.trade.sl.toString());
    _tp = TextEditingController(
        text: widget.trade.tp == null ? null : widget.trade.tp.toString());
    _entryPrice = TextEditingController(
        text: widget.trade.entryPrice == null
            ? null
            : widget.trade.entryPrice.toString());
    _closePrice = TextEditingController(
        text: widget.trade.closePrice == null
            ? null
            : widget.trade.closePrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _symbol,
            decoration: buildInputDecoration(context, 'Symbol'),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Entry time',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Row(
            children: <Widget>[
              FlatButton.icon(
                onPressed: () async {
                  DateTime newDate = await showDatePicker(
                    context: context,
                    initialDate: DateFormat.yMd()
                        .parse(DateFormat.yMd().format(DateTime.now())),
                    firstDate: DateTime(2018),
                    lastDate: DateTime.now(),
                  );
                  if (newDate != null) {
                    setState(() {
                      widget.trade.entryTime = widget.trade.entryTime == null
                          ? newDate
                          : newDate.add(Duration(
                              hours: widget.trade.entryTime.hour,
                              minutes: widget.trade.entryTime.minute,
                            ));
                    });
                  }
                },
                icon: Icon(Icons.calendar_today),
                label: Text(widget.trade.entryTime == null
                    ? 'Select date'
                    : DateFormat.yMd().format(widget.trade.entryTime)),
              ),
              FlatButton.icon(
                onPressed: () async {
                  TimeOfDay newTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (newTime != null) {
                    if (widget.trade.entryTime == null) {
                      widget.trade.entryTime = DateFormat.yMd()
                          .parse(DateFormat.yMd().format(DateTime.now()))
                          .add(Duration(
                            hours: newTime.hour,
                            minutes: newTime.minute,
                          ));
                    } else {
                      widget.trade.entryTime = DateFormat.yMd()
                          .parse(
                              DateFormat.yMd().format(widget.trade.entryTime))
                          .add(Duration(
                            hours: newTime.hour,
                            minutes: newTime.minute,
                          ));
                    }

                    setState(() {});
                  }
                },
                icon: Icon(Icons.access_time),
                label: Text(widget.trade.entryTime == null
                    ? 'Entry time'
                    : DateFormat.Hm().format(widget.trade.entryTime)),
              ),
            ],
          ),
          TextFormField(
            controller: _entryPrice,
            decoration: buildInputDecoration(context, 'Entry price'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextFormField(
            controller: _volume,
            decoration: buildInputDecoration(context, 'Volume'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextFormField(
            controller: _sl,
            decoration: buildInputDecoration(context, 'Stop Loss price'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextFormField(
            controller: _tp,
            decoration: buildInputDecoration(context, 'Take Profit price'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextFormField(
            controller: _entryReason,
            decoration: buildInputDecoration(context, 'Entry Reason'),
            minLines: 1,
            maxLines: 5,
          ),
          TextFormField(
            controller: _tradeManagement,
            decoration: buildInputDecoration(context, 'Trade Management'),
            minLines: 1,
            maxLines: 5,
          ),
          SizedBox(
            height: 20,
          ),
          CheckboxListTile(
            value: widget.trade.closed,
            onChanged: (value) {
              setState(() {
                debugPrint('Button pressed!! Value is $value');
                widget.trade.closed = value;
              });
            },
            title: Text('Closed?'),
          ),
          TextFormField(
            controller: _closePrice,
            decoration: buildInputDecoration(context, 'Close price'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            enabled: widget.trade.closed,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Close time',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: !widget.trade.closed ? Theme.of(context).disabledColor : Colors.black87,)
            ),
          ),
          Row(
            children: <Widget>[
              FlatButton.icon(
                  onPressed: !widget.trade.closed ? null : () async {
                    DateTime newDate = await showDatePicker(
                      context: context,
                      initialDate: DateFormat.yMd()
                          .parse(DateFormat.yMd().format(DateTime.now())),
                      firstDate: DateTime(2018),
                      lastDate: DateTime.now(),
                    );
                    if (newDate != null) {
                      setState(() {
                        widget.trade.closeTime = newDate;
                      });
                    }
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text(widget.trade.closeTime == null
                      ? 'Select date'
                      : DateFormat.yMd().format(widget.trade.closeTime)),
              ),
              FlatButton.icon(
                onPressed: !widget.trade.closed ? null : () async {
                  TimeOfDay newTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (newTime != null) {
                    if (widget.trade.closeTime == null) {
                      widget.trade.closeTime = DateFormat.yMd()
                          .parse(DateFormat.yMd().format(DateTime.now()))
                          .add(Duration(
                            hours: newTime.hour,
                            minutes: newTime.minute,
                          ));
                    } else {
                      widget.trade.closeTime = DateFormat.yMd()
                          .parse(
                              DateFormat.yMd().format(widget.trade.closeTime))
                          .add(Duration(
                            hours: newTime.hour,
                            minutes: newTime.minute,
                          ));
                    }

                    setState(() {});
                  }
                },
                icon: Icon(Icons.access_time),
                label: Text(widget.trade.closeTime == null
                    ? 'Close time'
                    : DateFormat.Hm().format(widget.trade.closeTime)),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: FractionallySizedBox(
              child: RaisedButton(
                onPressed: () {
                  debugPrint('Button pressed');
                },
                child: Text('Create the trade'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
              widthFactor: .8,
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      key: _formKey,
    );
  }

  InputDecoration buildInputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(width: 2, color: Theme.of(context).primaryColor)),
    );
  }

  bool _validate() {

    try {
      num.parse(_volume.text);
      _sl.text != '' || _sl.text != null ? num.parse(_sl.text): _sl.text;
      _tp.text != '' || _tp.text != null ? num.parse(_tp.text): _tp.text;
      num.parse(_entryPrice.text);
      _closePrice.text != '' || _closePrice.text != null ? num.parse(_closePrice.text): _closePrice.text;
    } catch (exception) {

    }
  }
}
