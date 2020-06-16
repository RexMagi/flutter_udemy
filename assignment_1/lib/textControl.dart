import 'package:flutter/material.dart';

class TextControl extends StatelessWidget {
  final Function updateText;

  TextControl(this.updateText);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(child: Text('Change Text'), onPressed: updateText);
  }
}
