import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctofTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctofTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constriants) {
      return Column(
        children: [
          Container(
              height: constriants.maxHeight * .15,
              child: FittedBox(
                  child: Text('\$${spendingAmount.toStringAsFixed(2)}'))),
          SizedBox(
            height: constriants.maxHeight * .05,
          ),
          Container(
            height: constriants.maxHeight * .60,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctofTotal,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10))),
                )
              ],
            ),
          ),
          SizedBox(
            height: constriants.maxHeight * .05,
          ),
          Container(
              height: constriants.maxHeight * .15,
              child: FittedBox(child: Text(label))),
        ],
      );
    });
  }
}
