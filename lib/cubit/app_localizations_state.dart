part of 'app_localizations_cubit.dart';

class AppLocalizationsState extends Equatable {
  const AppLocalizationsState({
    this.strings = const {},
  });

  final Map<String, AppLocalizationString> strings;

  @override
  List<Object> get props => [
        strings,
      ];

  AppLocalizationsState copyWith({
    Map<String, AppLocalizationString>? strings,
  }) {
    return AppLocalizationsState(
      strings: strings ?? this.strings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strings': strings.map((key, value) {
        return MapEntry(key, value.toJson());
      }),
    };
  }

  static AppLocalizationsState fromJson(Map<String, dynamic> json) {
    return AppLocalizationsState(
      strings: Map.fromEntries(
        (json['strings'] as Map<String, dynamic>).entries.map(
          (e) {
            return MapEntry(
              e.key,
              AppLocalizationString.fromJson(e.value as Map<String, dynamic>),
            );
          },
        ),
      ),
    );
  }
}

////

class AppLocalizationString extends Equatable {
  const AppLocalizationString({
    required this.key,
    required this.version,
    required this.comment,
    required this.localizations,
  });

  final String key;

  final int version;

  final String comment;

  final Map<Language, LocalizedString> localizations;

  @override
  List<Object?> get props => [key, version, localizations];

  AppLocalizationString copyWith({
    String? key,
    int? version,
    String? comment,
    Map<Language, LocalizedString>? localizations,
  }) {
    return AppLocalizationString(
      key: key ?? this.key,
      version: version ?? this.version,
      comment: comment ?? this.comment,
      localizations: localizations ?? this.localizations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'version': version,
      'comment': comment,
      'localizations': localizations.map((key, value) {
        return MapEntry(key.code, value.toJson());
      }),
    };
  }

  static AppLocalizationString fromJson(Map<String, dynamic> json) {
    return AppLocalizationString(
      key: json['key'] as String,
      version: json['version'] as int,
      comment: json['comment'] as String,
      localizations: Map.fromEntries(
        (json['localizations'] as Map<String, dynamic>).entries.map(
          (e) {
            return MapEntry(
              Language.fromCode(e.key)!,
              LocalizedString.fromJson(e.value as Map<String, dynamic>),
            );
          },
        ),
      ),
    );
  }

  LocalizedStringState localizedStringStateFromLanguage(Language language) {
    final localizedString = localizations[language];
    if (localizedString == null) {
      return LocalizedStringState.untranslated;
    }
    if (localizedString.version != version) {
      return LocalizedStringState.needReview;
    }
    return LocalizedStringState.translated;
  }
}

/// 已本地化的字符串
class LocalizedString extends Equatable {
  const LocalizedString({
    required this.key,
    required this.value,
    required this.language,
    required this.version,
  });

  final String key;
  final String value;
  final Language language;
  final int version;

  @override
  List<Object?> get props => [
        key,
        value,
        language,
        version,
      ];
  LocalizedString copyWith({
    String? key,
    String? value,
    Language? language,
    int? version,
  }) {
    return LocalizedString(
      key: key ?? this.key,
      value: value ?? this.value,
      language: language ?? this.language,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'language': language.code,
      'version': version,
    };
  }

  static LocalizedString fromJson(Map<String, dynamic> json) {
    return LocalizedString(
      key: json['key'] as String,
      value: json['value'] as String,
      language: Language.fromCode(json['language'] as String)!,
      version: json['version'] as int,
    );
  }
}

enum Language {
  en('en', 'English'),
  ja('ja', 'Japanese'),
  ko('ko', 'Korean'),
  zh('zh', 'Chinese'),
  // ignore: constant_identifier_names
  zh_Hant('zh_Hant', 'Chinese (Traditional)'),
  // ignore: constant_identifier_names
  zh_Hans('zh_Hans', 'Chinese (Simplified)'),
  ;

  const Language(this.code, this.name);

  final String code;
  final String name;

  static Language? fromCode(String code) {
    final index = Language.values.indexWhere((element) => element.code == code);
    if (index == -1) {
      return null;
    }
    return Language.values[index];
  }
}

enum LocalizedStringState {
  /// 未翻译
  untranslated,

  /// 需要审核
  needReview,

  /// 已翻译
  translated,
}
