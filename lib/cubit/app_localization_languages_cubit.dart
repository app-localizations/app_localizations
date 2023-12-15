import 'package:app_localizations/cubit/app_localizations_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_localization_languages_state.dart';

class AppLocalizationLanguagesCubit
    extends HydratedCubit<AppLocalizationLanguagesState> {
  AppLocalizationLanguagesCubit()
      : super(const AppLocalizationLanguagesState());

  void changeSelectedLanguage(Language language) {
    emit(state.copyWith(selectedLanguage: language));
  }

  @override
  AppLocalizationLanguagesState? fromJson(Map<String, dynamic> json) {
    return AppLocalizationLanguagesState(
      sourceLanguage: Language.fromCode(json['sourceLanguage'])!,
      selectedLanguage: Language.fromCode(json['selectedLanguage'])!,
      supportedLanguages: (json['supportedLanguages'] as List<String>)
          .map((e) => Language.fromCode(e)!)
          .toList(),
      needTranslateStringCount: (json['needTranslateStringCount']
              as Map<String, dynamic>)
          .map((key, value) => MapEntry(Language.fromCode(key)!, value as int)),
    );
  }

  @override
  Map<String, dynamic>? toJson(AppLocalizationLanguagesState state) {
    return {
      'sourceLanguage': state.sourceLanguage.code,
      'selectedLanguage': state.selectedLanguage.code,
      'supportedLanguages':
          state.supportedLanguages.map((e) => e.code).toList(),
      'needTranslateStringCount': state.needTranslateStringCount
          .map((key, value) => MapEntry(key.code, value)),
    };
  }

  void updateNeedTranslateStringCount(Language language, int count) {
    emit(state.copyWith(
      needTranslateStringCount: {
        ...state.needTranslateStringCount,
        language: count,
      },
    ));
  }
}
