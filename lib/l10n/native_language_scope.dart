import 'package:flutter/widgets.dart';

class NativeLanguageScope extends InheritedWidget {
  const NativeLanguageScope({
    required this.languageCode,
    required super.child,
    super.key,
  });

  final String languageCode;

  static String languageCodeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<NativeLanguageScope>()!
      .languageCode;

  @override
  bool updateShouldNotify(NativeLanguageScope oldWidget) =>
      languageCode != oldWidget.languageCode;
}

extension NativeLanguageBuildContext on BuildContext {
  String get nativeLanguageCode => NativeLanguageScope.languageCodeOf(this);
}
