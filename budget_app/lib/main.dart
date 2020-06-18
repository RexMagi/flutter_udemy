import 'package:budget_app/widgets/chart.dart';
import 'package:budget_app/widgets/new_transactions.dart';
import 'package:budget_app/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'models/transaction.dart';

void main() {
  // below commented out code is used to restrict
  // device orientation to portrait
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(color: Colors.white),
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          primarySwatch: Colors.purple,
          accentColor: Colors.amber),
    );
    return materialApp;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    //   Transaction(
    //       id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    //   Transaction(
    //       id: 't2',
    //       title: 'Weekly Groceries',
    //       amount: 16.54,
    //       date: DateTime.now())
  ];

  bool _showChart = false;

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    setState(() {
      final newTransaction = Transaction(
          id: DateTime.now().toString(),
          title: title,
          amount: amount,
          date: date);

      _userTransactions.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builderContext) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addNewTransaction));
        });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (el) => el.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    var title = Text(
      'Personal Expenses',
      style: TextStyle(fontFamily: 'OpenSans'),
    );
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: title,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: title,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
    var txListWidget = Container(
        height: mediaQuery.size.height * .7 -
            mediaQuery.padding.top -
            appBar.preferredSize.height,
        child: TransactionList(_userTransactions, _deleteTransaction));
    var pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        if (isLandscape)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Show Chart',
                style: Theme.of(context).textTheme.headline6,
              ),
              Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  })
            ],
          ),
        if (!isLandscape)
          Container(
              height: mediaQuery.size.height * .3 -
                  mediaQuery.padding.top -
                  appBar.preferredSize.height,
              child: Chart(_recentTransactions)),
        if (!isLandscape) txListWidget,
        _showChart
            ? Container(
                height: mediaQuery.size.height * .7 -
                    mediaQuery.padding.top -
                    appBar.preferredSize.height,
                child: Chart(_recentTransactions))
            : txListWidget,
      ]),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
