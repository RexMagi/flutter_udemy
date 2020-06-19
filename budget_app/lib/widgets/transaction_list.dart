import 'package:budget_app/widgets/transaction_item.dart';
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
                  return TransactionItem(
                      transaction: transaction,
                      deleteTransaction: _deleteTransaction);
                },
                itemCount: _userTransactions.length,
              ));
  }
}
