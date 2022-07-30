import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:introduction_story/introduction_story.dart';

void main() {
  group('IntroductionStoryScreen', () {
    test(
      'Throws AssertionError when stories list is empty.',
      () {
        expect(
          () => IntroductionStoryScreen(stories: const []),
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
          () => IntroductionStoryScreen(stories: stories, duration: 500),
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
          () => IntroductionStoryScreen(
            stories: stories,
            hideSkipButton: true,
          ),
          throwsAssertionError,
        );
      },
    );
  });
}
