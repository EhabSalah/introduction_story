import 'package:flutter_test/flutter_test.dart';
import 'package:story_introduction/story_introduction.dart';

void main() {
  group('Story', () {
    test(
      'Throws AssertionError when '
      'neither a background image path nor color has been set.',
      () => expect(Story.new, throwsAssertionError),
    );
  });
}
