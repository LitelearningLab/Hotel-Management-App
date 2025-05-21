double kHeight = 0.0;
double kWidth = 0.0;
// double fullScreenHeight = 805.33;

double getWidgetHeight({required double height}) {
  double variableHeightValue = 812 / height;
  return kHeight / variableHeightValue;
}

double getWidgetWidth({required double width}) {
  double variableWidthValue = 375 / width;
  return kWidth / variableWidthValue;
}

// double getFullWidgetHeight({required double height}) {
//   double variableHeightValue = 812 / height;
//   return fullScreenHeight / variableHeightValue;
// }
