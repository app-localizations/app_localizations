import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState(
      isShowKey: json['isShowKey'] ?? false,
      isHighlightSpace: json['isHighlightSpace'] ?? false,
      isHighlightParameter: json['isHighlightParameter'] ?? false,
    );
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return {
      'isShowKey': state.isShowKey,
      'isHighlightSpace': state.isHighlightSpace,
      'isHighlightParameter': state.isHighlightParameter,
    };
  }
}
