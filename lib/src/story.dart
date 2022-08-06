import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Story {
  final Color? backgroundColor;
  final String? imagePath;
  // ignore:library_private_types_in_public_api
  final _StoryTheme storyThemeMode;
  final Widget? foreground;

  Story({
    this.backgroundColor,
    this.imagePath,
    this.foreground,
    bool lightMode = true,
  })  : assert(imagePath != null || backgroundColor != null,
            'imagePath or backgroundColor must be set, to be used as a background'),
        storyThemeMode = _StoryTheme(lightMode);
}

class _StoryTheme {
  final Color foregroundColor;
  final Brightness brightness;

  _StoryTheme(bool lightTheme)
      : foregroundColor =
            lightTheme ? const Color(0xffffffff) : const Color(0xff000000),
        brightness = lightTheme ? lightBrightness() : darkBrightness();

  // For iOS.
  // Use [dark] for white status bar and [light] for black status bar.
  static lightBrightness() =>
      Platform.isIOS ? Brightness.dark : Brightness.light;

  static darkBrightness() =>
      Platform.isIOS ? Brightness.light : Brightness.dark;
}
