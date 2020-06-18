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
        child: _userTransactions.isEmpty
            ? LayoutBuilder(builder: (ctx, constraints) {
                return Column(
                  children: <Widget>[
                    Text('No transactions added yet!',
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: constraints.maxHeight * .6,
                      child: Image.asset(
                        'assests\\images\\waiting.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              })
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
                      trailing: MediaQuery.of(context).size.width > 400
                          ? FlatButton.icon(
                              label: Text('Delete'),
                              icon: Icon(Icons.delete),
                              textColor: Theme.of(context).errorColor,
                              onPressed: () =>
                                  _deleteTransaction(transaction.id))
                          : IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () =>
                                  _deleteTransaction(transaction.id),
                            ),
                    ),
                  );
                },
                itemCount: _userTransactions.length,
              ));
  }
}
