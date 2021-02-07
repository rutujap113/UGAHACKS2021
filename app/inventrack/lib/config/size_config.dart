import 'package:flutter/cupertino.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaVertical;
  static double _safeAreaHorizontal;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    blockSizeHorizontal = _mediaQueryData.size.width;
    blockSizeVertical = _mediaQueryData.size.height;

    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;

    screenWidth = (blockSizeHorizontal - _safeAreaHorizontal);
    screenHeight = (blockSizeVertical - _safeAreaVertical);
  }
}
