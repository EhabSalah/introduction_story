import 'package:story_introduction/src/model/story_decoration.dart';

/// {@template story_}
/// [Story] represents each story properties.
/// {@endtemplate}
class Story {
  /// {@macro story_}
  Story({
    this.featureName = '',
    this.title = '',
    this.description = '',
    this.imagePath,
    this.decoration = const StoryDecoration(),
  }) : assert(
          imagePath != null || decoration.backgroundColor != null,
          'imagePath or backgroundColor must be provided!',
        );

  /// Name of the story.
  final String featureName;

  /// Title of the story.
  final String title;

  /// Description of the story.
  final String description;

  /// Story background image.
  final String? imagePath;

  /// Story decoration
  /// Contains all story customizations, like color, brightness, text styles.
  final StoryDecoration decoration;
}
