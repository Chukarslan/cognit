import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'es', 'fr', 'zh_Hans', 'ar'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? esText = '',
    String? frText = '',
    String? zh_HansText = '',
    String? arText = '',
  }) =>
      [enText, esText, frText, zh_HansText, arText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return FFLocalizations.languages().contains(
      language.endsWith('_')
          ? language.substring(0, language.length - 1)
          : language,
    );
  }

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    'qtxe7kmv': {
      'en': '© Cognit demonstator. All Rights Reserved.',
      'ar': '© FlutterFlow 2023. جميع الحقوق محفوظة.',
      'es': '© FlutterFlow 2023. Todos los derechos reservados.',
      'fr': '© FlutterFlow 2023. Tous droits réservés.',
      'zh_Hans': '© FlutterFlow 2023。保留所有权利。',
    },
    '3v0v72l0': {
      'en': 'Home',
      'ar': 'بيت',
      'es': 'Hogar',
      'fr': 'Maison',
      'zh_Hans': '家',
    },
  },
  // Miscellaneous
  {
    'pg9c1qnw': {
      'en': 'We need access to the microphone to answer your response.',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    '8e7cig2m': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'p9bvo0b7': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'alj77qkb': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    '46dk9j0z': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'brdb3wib': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'rcy7xsfq': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'd326hkal': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'de1vak77': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'nozfze42': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'ccgbucr2': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'i3bzn6dc': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'irlsxlzs': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'zg5zovhx': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'nj0m6aaf': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'mxozzws0': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'xb6a9gev': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'p71s4r51': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'pp6nldfy': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'fc4ik49r': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'xpx239r5': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'ki8ktjw4': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    'tpbq48c7': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
    '3okfrl08': {
      'en': '',
      'ar': '',
      'es': '',
      'fr': '',
      'zh_Hans': '',
    },
  },
].reduce((a, b) => a..addAll(b));
