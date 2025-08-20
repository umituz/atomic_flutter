import 'package:flutter/material.dart';

class AtomicSpacing {
  AtomicSpacing._();

  static const double unit = 8.0;

  static const double xxs = unit * 0.5;  // 4
  static const double xs = unit * 1;     // 8
  static const double sm = unit * 1.5;   // 12
  static const double md = unit * 2;     // 16
  static const double lg = unit * 3;     // 24
  static const double xl = unit * 4;     // 32
  static const double xxl = unit * 5;    // 40
  static const double xxxl = unit * 6;   // 48
  static const double huge = unit * 8;   // 64

  static const double buttonPaddingX = md;
  static const double buttonPaddingY = sm;
  
  static const double cardPadding = lg;
  static const double cardMargin = md;
  
  static const double listItemPadding = md;
  static const double listItemSpacing = xs;
  
  static const double inputPaddingX = md;
  static const double inputPaddingY = sm;
  
  static const double modalPadding = lg;
  static const double sectionPadding = xl;
  
  static const EdgeInsets zero = EdgeInsets.zero;
  
  static EdgeInsets all(double value) => EdgeInsets.all(value);
  static const EdgeInsets allXxs = EdgeInsets.all(xxs);
  static const EdgeInsets allXs = EdgeInsets.all(xs);
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allMd = EdgeInsets.all(md);
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  static const EdgeInsets allXl = EdgeInsets.all(xl);
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);
  
  static EdgeInsets horizontal(double value) => EdgeInsets.symmetric(horizontal: value);
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);
  
  static EdgeInsets vertical(double value) => EdgeInsets.symmetric(vertical: value);
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
  
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) => 
    EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  
  static const EdgeInsets listPadding = EdgeInsets.symmetric(horizontal: md, vertical: xs);
  static const EdgeInsets cardContentPadding = EdgeInsets.all(lg);
  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets buttonContentPadding = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
} 