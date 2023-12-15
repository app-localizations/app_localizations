part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.isShowKey = true,
    this.isHighlightSpace = true,
    this.isHighlightParameter = true,
  });

  // 是否展示Kye
  final bool isShowKey;

  // 是否高亮文本前后缀空格
  final bool isHighlightSpace;

  // 是否高亮文本内参数
  final bool isHighlightParameter;

  @override
  List<Object> get props => [
        isShowKey,
        isHighlightSpace,
        isHighlightParameter,
      ];
}
