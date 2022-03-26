import 'dart:math';

import 'package:flutter/material.dart';

class TiaLinkIcons {
  TiaLinkIcons._();

  static const _kFontFam = 'TiaLinkIcons';
  static const String? _kFontPkg = null;

  static const IconData alpha_d = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData alpha_c = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData alpha_b = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData alpha_a = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

IconData indexToAlphabetIcon(int i) {
  switch (i) {
    case 0:
      return TiaLinkIcons.alpha_a;
    case 1:
      return TiaLinkIcons.alpha_b;
    case 2:
      return TiaLinkIcons.alpha_c;
    case 3:
      return TiaLinkIcons.alpha_d;
    default:
      return Icons.settings_remote_rounded;
  }
}

int randomInt(int length) {
  const _chars = '1234567890';
  Random _random = Random();
  var s = (_random.nextInt(9) + 1).toString();

  s += String.fromCharCodes(
      Iterable.generate(length - 1, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
  return s.toInt();
}

extension NumberParsing on String {
  int toInt() => int.parse(this);
}
