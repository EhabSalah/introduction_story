import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:story_introduction/story_introduction.dart';

void main() {
  group('StoryIntroductionScreen', () {
    test(
      'Throws AssertionError when stories list is empty.',
      () {
        expect(
          () => StoryIntroductionScreen(stories: const []),
          throwsAssertionError,
        );
      },
    );

    test(
      'Throws AssertionError when duration value is less than 1000 ms.',
      () {
        // arrange
        final stories = [
          Story(decoration: const StoryDecoration(backgroundColor: Colors.red))
        ];

        expect(
          () => StoryIntroductionScreen(stories: stories, duration: 500),
          throwsAssertionError,
        );
      },
    );

    test(
      'Throws AssertionError when the two options to close/dismiss screen are not enabled.',
      () {
        // arrange
        final stories = [
          Story(decoration: const StoryDecoration(backgroundColor: Colors.red))
        ];

        expect(
          () => StoryIntroductionScreen(
            stories: stories,
            hideSkipButton: true,
          ),
          throwsAssertionError,
        );
      },
    );
  });
}
