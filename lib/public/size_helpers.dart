import 'package:flutter/material.dart';

double globalFontSize(double fontSize, BuildContext context) {
  TextScaler text = MediaQuery.of(context).textScaler;
  return text.scale(fontSize);
}

Size displaySize(BuildContext context) {
  //debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  //debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}
