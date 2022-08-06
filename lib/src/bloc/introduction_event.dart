part of '../bloc/introduction_bloc.dart';

@immutable
abstract class IntroductionEvent {
  const IntroductionEvent();
}

class IntroductionStarted extends IntroductionEvent {
  const IntroductionStarted();
}

class IntroductionTicked extends IntroductionEvent {
  final int progress;

  const IntroductionTicked(this.progress);
}

class IntroductionPrevious extends IntroductionEvent {
  const IntroductionPrevious();
}

class IntroductionNext extends IntroductionEvent {
  const IntroductionNext();
}

class IntroductionPause extends IntroductionEvent {
  const IntroductionPause();
}

class IntroductionResume extends IntroductionEvent {
  const IntroductionResume();
}
