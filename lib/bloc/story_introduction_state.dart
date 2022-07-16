part of '../widgets/story_introduction_screen.dart';

@immutable
abstract class _StoryIntroductionState {
  final int currentStoryIndex;
  final List<double> storiesWatchProgress;

  const _StoryIntroductionState(
      {required this.currentStoryIndex, required this.storiesWatchProgress});
}

class _WatchProgress extends _StoryIntroductionState {
  const _WatchProgress(
      {required int currentStoryIndex, required List<double> watchProgress})
      : super(
            currentStoryIndex: currentStoryIndex,
            storiesWatchProgress: watchProgress);
}

class _End extends _StoryIntroductionState {
  const _End(
      {required int currentStoryIndex, required List<double> watchProgress})
      : super(
            currentStoryIndex: currentStoryIndex,
            storiesWatchProgress: watchProgress);
}
