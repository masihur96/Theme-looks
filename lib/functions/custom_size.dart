import 'package:flutter/cupertino.dart';

double screenSize(BuildContext context, double partialSize) {
  var screenSize = MediaQuery.of(context).size.width;
  return screenSize * partialSize;
}
