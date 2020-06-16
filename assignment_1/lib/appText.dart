import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String renderText;

  AppText(this.renderText);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppText(renderText),
    );
  }
}
