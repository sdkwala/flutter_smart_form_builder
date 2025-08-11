import 'package:flutter/material.dart';

class SmartFormThemeData {
  final EdgeInsets fieldPadding;
  final TextStyle? labelStyle;
  final InputDecoration? inputDecoration;
  final Widget Function(List<Widget> fields)? layout;

  const SmartFormThemeData({
    this.fieldPadding = const EdgeInsets.symmetric(vertical: 8.0),
    this.labelStyle,
    this.inputDecoration,
    this.layout,
  });
}

class SmartFormTheme extends InheritedWidget {
  final SmartFormThemeData data;

  const SmartFormTheme({Key? key, required this.data, required Widget child}) : super(key: key, child: child);

  static SmartFormThemeData of(BuildContext context) {
    final SmartFormTheme? theme = context.dependOnInheritedWidgetOfExactType<SmartFormTheme>();
    return theme?.data ?? const SmartFormThemeData();
  }

  @override
  bool updateShouldNotify(SmartFormTheme oldWidget) => data != oldWidget.data;
} 