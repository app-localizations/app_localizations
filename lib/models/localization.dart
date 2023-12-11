// // ignore_for_file: constant_identifier_names

// class AppLocalizations {
//   const AppLocalizations({
//     this.sourceLanguage = Language.en,
//     this.strings = const {},
//   });

//   final Language sourceLanguage;

//   final Map<String, AppLocalizationString> strings;
// }

// class AppLocalizationString {
//   const AppLocalizationString({
//     required this.key,
//     required this.version,
//     required this.localizations,
//   });

//   final String key;

//   final int version;

//   final Map<Language, LocalizedString> localizations;
// }

// /// 已本地化的字符串
// class LocalizedString {
//   const LocalizedString({
//     required this.key,
//     required this.value,
//     required this.languageCode,
//     required this.version,
//   });

//   final String key;
//   final String value;
//   final Language languageCode;
//   final int version;
// }

// enum Language {
//   en('en', 'English'),
//   ja('ja', 'Japanese'),
//   ko('ko', 'Korean'),
//   zh('zh', 'Chinese'),
//   zh_Hant('zh-Hant', 'Chinese (Traditional)'),
//   zh_Hans('zh-Hans', 'Chinese (Simplified)'),
//   ;

//   const Language(this.code, this.name);

//   final String code;
//   final String name;
// }
