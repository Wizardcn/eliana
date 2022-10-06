import 'package:flutter/widgets.dart';

class CustomIcon {
  CustomIcon._();

  static const _kFontFam = 'MyFlutterApp';
  static const String? _kFontPkg = null;

  static const IconData mic =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
