import 'package:introduction_story/src/model/story_decoration.dart';

/// {@template story_}
/// [Story] represents each story properties.
/// {@endtemplate}
class Story {
  /// {@macro story_}
  Story({
    this.name = '',
    this.title = '',
    this.description = '',
    required this.imagePath,
    this.decoration = const StoryDecoration(),
  }) : assert(
           decoration.backgroundColor != null,
          'backgroundColor must be provided!',
        )
        ;

  /// Name of the story.
  final String name;

  /// Title of the story.
  final String title;

  /// Description of the story.
  final String description;

  /// Story background image.
  final String imagePath;

  /// Story decoration
  /// Contains all story customizations, like color, brightness, text styles.
  final StoryDecoration decoration;
}
