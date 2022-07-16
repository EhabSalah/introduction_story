import 'dart:ui';

class Story {
  final String title;
  final String description;
  final Color? backgroundColor;
  final String? imagePath;

  Story({
    required this.title,
    required this.description,
    this.backgroundColor,
    this.imagePath,
  }) : assert(imagePath != null || backgroundColor != null);
}
