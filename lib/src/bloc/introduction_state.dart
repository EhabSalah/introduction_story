part of '../bloc/introduction_bloc.dart';

/// {@template introduction_state}
/// Base class for all [IntroductionState]s which are
/// managed by the [IntroductionBloc].
/// {@endtemplate}
abstract class IntroductionState extends Equatable {
  /// {@macro introduction_state}
  const IntroductionState(this.index, this.watchProgress);

  /// Index of the current story.
  final int index;

  /// Each index in the list represents the watch progress
  /// of the corresponding story.
  final List<int> watchProgress;

  /// Watch progress of the current story.
  int get currentStoryProgress => watchProgress[index];

  @override
  List<Object?> get props => [index, watchProgress];
}

/// {@template introduction_initial}
/// Initial state of the [IntroductionBloc].
/// {@endtemplate}
class IntroductionInitial extends IntroductionState {
  /// {@macro introduction_initial}
  const IntroductionInitial(super.index, super.watchProgress);

  @override
  String toString() => '${(IntroductionInitial).toString()} '
      '{ index: $index, watchProgress: $watchProgress }';
}

/// {@template introduction_run_in_progress}
/// The state of [IntroductionBloc], after a [Ticker] has been started.
/// {@endtemplate}
class IntroductionRunInProgress extends IntroductionState {
  /// {@macro introduction_run_in_progress}
  const IntroductionRunInProgress(super.index, super.watchProgress);

  @override
  String toString() => '${(IntroductionRunInProgress).toString()} '
      '{ index: $index, watchProgress: $watchProgress }';
}

/// {@template introduction_run_complete}
/// The state of the [IntroductionBloc] after the ticker of
/// the [Ticker] of the last story has completed.
/// {@endtemplate}
class IntroductionRunComplete extends IntroductionState {
  /// {@macro introduction_run_complete}
  const IntroductionRunComplete() : super(0, const []);

  @override
  String toString() => '${(IntroductionRunComplete).toString()} '
      '{ index: $index, watchProgress: $watchProgress }';
}
