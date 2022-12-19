import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Responsiveness {
  static late Responsiveness _instance;
  static const Size defaultSize = Size(360, 640);

  Size uiSize = defaultSize;

  bool allowFontScaling = true;

  static late num _screenWidth;
  static late num _screenHeight;
  static late num _pixelRatio;
  static late num _statusBarHeight;
  static late num _bottomBarHeight;
  static late num _textScaleFactor;
  // SafeArea vars
  static late num _safeAreaHorizontal;
  static late num _safeAreaVertical;
  static late num _safeArea;
  static late num _safeWidth;
  static late num _safeHeight;

  Responsiveness._() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = mediaQuery.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;
    _safeAreaHorizontal = mediaQuery.padding.left + mediaQuery.padding.right;
    _safeAreaVertical = mediaQuery.padding.top + mediaQuery.padding.bottom;
    _safeArea = _safeAreaHorizontal + _safeAreaVertical;
    _safeWidth =
        _screenWidth - mediaQuery.padding.left - mediaQuery.padding.right;
    _safeHeight = _screenHeight - _statusBarHeight - _bottomBarHeight;
  }

  factory Responsiveness() {
    return _instance;
  }

  static void init({
    Size designSize = defaultSize,
    bool allowFontScaling = false,
  }) {
    _instance = Responsiveness._();
    _instance
      ..uiSize = designSize
      ..allowFontScaling = allowFontScaling;
  }

  static num get textScaleFactor => _textScaleFactor;

  /// The size of the media in logical pixels (e.g, the size of the screen).
  static num get pixelRatio => _pixelRatio;

  /// The horizontal extent of this size.
  static num get screenWidth => _screenWidth;

  /// The vertical extent of this size. dp
  static num get screenHeight => _screenHeight;

  /// The vertical extent of this size. px
  static num get screenWidthPx => _screenWidth * _pixelRatio;

  /// The vertical extent of this size. px
  static num get screenHeightPx => _screenHeight * _pixelRatio;

  /// The offset from the top
  static num get statusBarHeight => _statusBarHeight;

  /// The offset from the bottom.
  static num get bottomBarHeight => _bottomBarHeight;

  /// Safe Area(Vertical +  Horizontal)
  static num get safeArea => _safeArea;

  /// Safe Area horizontal
  static num get safeAreaHorizontal => _safeAreaHorizontal;

  /// Safe Area Vertical
  static num get safeAreaVertical => _safeAreaVertical;

  /// The ratio of the actual dp to the design draft px
  num get scaleWidth => _screenWidth / uiSize.width;

  num get scaleHeight => _screenHeight / uiSize.height;

  num get scaleText => scaleWidth;

  /// safeAreaScaleWidth
  num get scaleSafeAreaWidth => _safeWidth / uiSize.width;

  /// safeAreaScaleWidth
  num get scaleSafeAreaHeight => _safeHeight / uiSize.height;

  num get scaleSafeAreaText => scaleSafeAreaWidth;

  /// Adapted to the device width of the UI Design.
  /// Height can also be adapted according to this to ensure no deformation ,
  /// if you want a square
  num setWidth(num width) => width * scaleWidth;

  /// Highly adaptable to the device according to UI Design
  /// It is recommended to use this method to achieve a high degree of adaptation
  /// when it is found that one screen in the UI design
  /// does not match the current style effect, or if there is a difference in shape.
  num setHeight(num height) => height * scaleHeight;

  num setSafeAreaWidth(num width) => width * scaleSafeAreaWidth;

  num setSafeAreaHeight(num height) => height * scaleSafeAreaHeight;

  num setSpacing(num spacing) => spacing * scaleWidth;

  num setHorizontalSpacing(num spacing) => spacing * scaleWidth;

  num setVerticalSpacing(num spacing) => spacing * scaleHeight;

  num setSafeAreaSpacing(num spacing) => spacing * scaleSafeAreaWidth;

  /// Horizontal Spacing function
  num setSafeAreaHorizontalSpacing(num spacing) => spacing * scaleSafeAreaWidth;

  /// Vertical Spacing function
  num setSafeAreaVerticalSpacing(num spacing) => spacing * scaleSafeAreaHeight;

  /// Icon sizing function
  num setIconSize(num size) => size * scaleWidth;

  /// Icon sizing function
  num setSafeAreaIconSize(num size) => size * scaleSafeAreaWidth;

  ///@param [fontSize]
  ///Font size adaptation method
  ///@param [fontSize] The size of the font on the UI design, in px.
  ///@param [allowFontScaling]
  num setFontSize(num fontSize, {bool? allowFontScalingSelf}) =>
      allowFontScalingSelf == null
          ? (allowFontScaling
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _textScaleFactor))
          : (allowFontScalingSelf
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _textScaleFactor));

  ///@param [fontSize]
  ///Font size adaptation method
  ///@param [fontSize] The size of the font on the SafeArea UI design, in px.
  ///@param [allowFontScaling]
  num setSafeAreaFontSize(num fontSize, {bool? allowFontScalingSelf}) =>
      allowFontScalingSelf == null
          ? (allowFontScaling
              ? (fontSize * scaleSafeAreaText)
              : ((fontSize * scaleSafeAreaText) / _textScaleFactor))
          : (allowFontScalingSelf
              ? (fontSize * scaleSafeAreaText)
              : ((fontSize * scaleSafeAreaText) / _textScaleFactor));
}

extension ResponsivenessExtension on num {
  // shorthand for width
  double get w => Responsiveness().setWidth(this) as double;

  // shorthand for height
  double get h => Responsiveness().setHeight(this) as double;

  // shorthand for fontsize
  double get f => Responsiveness().setFontSize(this) as double;

  // shorthand for spacing(Padding, margin)
  double get s => Responsiveness().setSpacing(this) as double;

  // shorthand for spacing(Vertical Padding, Vertical margin)
  double get vs => Responsiveness().setVerticalSpacing(this) as double;

  // shorthand for spacing(Horizontal Padding, Horizontal margin)
  double get hs => Responsiveness().setHorizontalSpacing(this) as double;

  // shorthand for icon size
  double get ics => Responsiveness().setIconSize(this) as double;

  // shorthand for safe width
  double get sw => Responsiveness().setSafeAreaWidth(this) as double;

  // shorthand for safe height
  double get sh => Responsiveness().setSafeAreaHeight(this) as double;

  // shorthand for safe fontsize
  double get sf => Responsiveness().setSafeAreaFontSize(this) as double;

  // shorthand for spacing(Padding, margin)
  double get ss => Responsiveness().setSafeAreaSpacing(this) as double;

  // shorthand for spacing(Vertical Padding, Vertical margin)
  double get svs => Responsiveness().setSafeAreaVerticalSpacing(this) as double;

  // shorthand for spacing(Vertical Padding, Vertical margin)
  double get shs => Responsiveness().setHorizontalSpacing(this) as double;

  // shorthand for icon size
  double get sics => Responsiveness().setSafeAreaIconSize(this) as double;

  // shorthand for circle diameter size
  double get d => Responsiveness().setWidth(this) as double;
}
