import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:story_introduction/src/model/story_decoration.dart';

void main() {
  group('StoryTheme', () {
    test(
      'Given default foregroundColor color based on lightMode '
      'when argument foregroundColor is null',
      () {
        expect(StoryTheme(lightMode: true).foregroundColor, Colors.white);
        expect(StoryTheme(lightMode: false).foregroundColor, Colors.black);
      },
    );

    test(
      'Given foregroundColor as red when red is passed '
      'as an argument of foregroundColor',
      () {
        final storyTheme =
            StoryTheme(lightMode: true, customForegroundColor: Colors.red);

        expect(storyTheme.foregroundColor, Colors.red);
      },
    );
  });
}
