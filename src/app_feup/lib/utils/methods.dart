import 'package:flutter/cupertino.dart';
import 'package:uni/utils/constants.dart';

/**
 * Horizontal Scaling according to device dimensions
 */
double hs(double value, BuildContext context) {
  final double width = MediaQuery.of(context).size.width;

  return value * (width / referenceWidth);
}

/**
 * Vertical Scaling according to device dimensions
 */
double vs(double value, BuildContext context) {
  final double height = MediaQuery.of(context).size.height;

  return value * (height / referenceHeight);
}