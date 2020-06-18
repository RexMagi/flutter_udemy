import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransactions;

  final Function _deleteTransaction;

  TransactionList(this._userTransactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 450,
        child: _userTransactions.isEmpty
            ? Column(
                children: <Widget>[
                  Text('No transactions added yet!',
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 200,
                    child: Image.asset(
                      'assests\\images\\waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  final transaction = _userTransactions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child:
                              FittedBox(child: Text('\$${transaction.amount}')),
                        ),
                      ),
                      title: Text(
                        transaction.title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle:
                          Text(DateFormat.yMMMd().format(transaction.date)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor,
                        onPressed: () => _deleteTransaction(transaction.id),
                      ),
                    ),
                  );
                },
                itemCount: _userTransactions.length,
              ));
  }
}
