part of '../widgets/story_introduction_screen.dart';

@immutable
abstract class _StoryIntroductionEvent {}

class _Start extends _StoryIntroductionEvent {}

class _TimerTick extends _StoryIntroductionEvent {}

class _PreviousStory extends _StoryIntroductionEvent {}

class _NextStory extends _StoryIntroductionEvent {}

class _Pause extends _StoryIntroductionEvent {}

class _Continue extends _StoryIntroductionEvent {}
