import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const unit = 16.0;

  static const double xxs = unit * 0.25;
  static const double xs = unit * 0.375;
  static const double sm = unit * 0.5;
  static const double md = unit * 0.75;
  static const double lg = unit;
  static const double xl = unit * 1.25;
  static const double xxl = unit * 1.5;
  static const double xxxl = unit * 2;
  static const double huge = unit * 2.5;

  static const pageInsets = EdgeInsets.all(xl);
  static const horizontalPageInsets = EdgeInsets.symmetric(horizontal: xl);
}
