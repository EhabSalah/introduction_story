import 'dart:io';

import 'package:flutter/material.dart';

/// {@template story_decoration}
/// [StoryDecoration] gives the ability to decorate story.
/// {@endtemplate}
class StoryDecoration {
  /// {@macro story_decoration}
  const StoryDecoration({
    this.lightMode = true,
    Color? foregroundColor,
    this.backgroundColor = Colors.transparent,
    TextStyle titleTextStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    TextStyle descriptionTextStyle = const TextStyle(
      fontSize: 13,
      height: 1.4,
    ),
    TextStyle nameTextStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
    ),
  })  : _foregroundColor = foregroundColor,
        _titleTextStyle = titleTextStyle,
        _descriptionTextStyle = descriptionTextStyle,
        _nameTextStyle = nameTextStyle;

  final Color? _foregroundColor;

  /// Story background color.
  final Color? backgroundColor;

  final TextStyle _titleTextStyle;

  /// TextStyle for title
  ///
  /// @Default style `fontSize: 24.0, fontWeight: FontWeight.bold`
  TextStyle get titleTextStyle =>
      _titleTextStyle.copyWith(color: storyTheme.foregroundColor);

  /// TextStyle for title
  ///
  /// @Default style `fontSize: 13.0, height: 1.4`
  TextStyle get descriptionTextStyle =>
      _descriptionTextStyle.copyWith(color: storyTheme.foregroundColor);

  /// TextStyle for title
  ///
  /// @Default style `fontSize: 12.0, fontWeight: FontWeight.w600`
  TextStyle get nameTextStyle =>
      _nameTextStyle.copyWith(color: storyTheme.foregroundColor);

  /// Story theme
  StoryTheme get storyTheme => StoryTheme(
        lightMode: lightMode,
        customForegroundColor: _foregroundColor,
      );

  final TextStyle _descriptionTextStyle;

  final TextStyle _nameTextStyle;

  /// Use light brightness for the story.
  ///
  /// @Default: `true`
  final bool lightMode;
}

/// {@template story_temp}
/// [StoryTheme] represents the theme of story.
/// {@endtemplate}
class StoryTheme {
  /// {@macro story_temp}
  StoryTheme({required bool lightMode, Color? customForegroundColor})
      : foregroundColor =
            customForegroundColor ?? (lightMode ? Colors.white : Colors.black),
        brightness = lightMode ? _lightBrightness() : _darkBrightness();

  /// Story foreground color (used for text, progress bars)
  final Color foregroundColor;

  /// Status bar brightness.
  final Brightness brightness;

// For iOS use [dark] for white status bar and [light] for black status bar.
  static Brightness _lightBrightness() =>
      Platform.isIOS ? Brightness.dark : Brightness.light;

  static Brightness _darkBrightness() =>
      Platform.isIOS ? Brightness.light : Brightness.dark;
}
