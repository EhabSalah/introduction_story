part of '../bloc/introduction_bloc.dart';

/// {@template introduction_event}
/// Base class for all [IntroductionEvent]s which are
/// handled by the [IntroductionBloc].
/// {@endtemplate}
abstract class IntroductionEvent {
  /// {@macro introduction_event}
  const IntroductionEvent();
}

/// {@template introduction_started}
/// Signifies to the [IntroductionBloc] that the user
/// has started to watch the introduction.
/// {@endtemplate}
class IntroductionStarted extends IntroductionEvent {
  /// {@macro introduction_started}
  const IntroductionStarted();
}

// Internal event used to signifies to the IntroductionBloc
// that the ticker has ticked and reached specific progress.
class _IntroductionTicked extends IntroductionEvent {
  const _IntroductionTicked(this.progress);

  final int progress;
}

/// {@template introduction_previous}
/// Signifies to the [IntroductionBloc] that the user
/// has requested to see the previous story.
/// {@endtemplate}
class IntroductionPrevious extends IntroductionEvent {
  /// {@macro introduction_previous}
  const IntroductionPrevious();
}

/// {@template introduction_next}
/// Signifies to the [IntroductionBloc] that the user
/// has requested to skip to the next story.
/// {@endtemplate}
class IntroductionNext extends IntroductionEvent {
  /// {@macro introduction_next}
  const IntroductionNext();
}

/// {@template introduction_pause}
/// Signifies to the [IntroductionBloc] that the user
/// has requested to pause watching the introduction.
/// {@endtemplate}
class IntroductionPause extends IntroductionEvent {
  /// {@macro introduction_pause}
  const IntroductionPause();
}

/// {@template introduction_resume}
/// Signifies to the [IntroductionBloc] that the user
/// has requested to resume watching the introduction.
/// {@endtemplate}
class IntroductionResume extends IntroductionEvent {
  /// {@macro introduction_resume}
  const IntroductionResume();
}
