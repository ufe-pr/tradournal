import 'package:flutter/material.dart';
import 'package:trader_journal/ui/home_page.dart';
import 'package:trader_journal/ui/splash_screen.dart';
import 'package:trader_journal/ui/add_edit_trade.dart';

void main() => runApp(MyApp());

var routes = {
  '/' : (context) => Splash(),
  '/home' : (context) => Home(),
  'add-edit-trade': (context) => AddEditTrade(),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tradournal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
      initialRoute: '/home',
    );
  }
}
