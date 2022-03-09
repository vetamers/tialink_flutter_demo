import 'package:flutter/material.dart';
import 'package:tialink/ui/icons.dart';

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