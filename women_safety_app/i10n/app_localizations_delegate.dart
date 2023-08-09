import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  late Map<String, String> _localizedStrings;

  Future<void> load() async {
    final jsonString =
        await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String? translate(String key) {
    return _localizedStrings[key];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
