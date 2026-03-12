import 'package:flutter/material.dart';
import 'package:new_standred/core/config/locale/app_localizations.dart';

class Loc {
  /// Translate key quickly
  static String tr(BuildContext context, String key) {
    return AppLocalizations.of(context)!.translate(key)!;
  }
}
