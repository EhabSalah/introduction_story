import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'introduction_event.dart';

part 'introduction_state.dart';

/// The minimum duration for a story in milliseconds.
const minimumStoryDuration = 1000;

/// The value of a complete story watch progress.
const completeWatchProgress = 100;

/// {@template introduction_run_in_progress}
/// [IntroductionBloc] which manages [IntroductionState].
/// {@endtemplate}
class IntroductionBloc extends Bloc<IntroductionEvent, IntroductionState> {
  /// Creates an instance of [IntroductionBloc], and depends on [storiesLength].
  ///
  /// {@macro introduction_run_in_progress}
  IntroductionBloc({
    required int storiesLength,
    int storyDuration = minimumStoryDuration,
    @visibleForTesting Ticker? ticker, // Optional for testing.
    @visibleForTesting int completeWatchProgress = completeWatchProgress,
  })  : _storiesLength = storiesLength,
        _storyDuration = storyDuration,
        _completeWatchProgress = completeWatchProgress,
        _ticker = ticker ?? Ticker(),
        assert(storiesLength > 0, 'Stories count should be more than zero!'),
        assert(
          storyDuration >= minimumStoryDuration,
          'Story duration should be >= $minimumStoryDuration ms.',
        ),
        super(IntroductionInitial(0, List.generate(storiesLength, (_) => 0))) {
    on<IntroductionStarted>(_onStarted);

    on<_IntroductionTicked>(_onTicked);

    on<IntroductionPrevious>(_onPrevious);

    on<IntroductionNext>(_onNext);

    on<IntroductionPause>(_onPause);

    on<IntroductionResume>(_onResumed);
  }

  final int _completeWatchProgress;

  // The progress counter for the whole mechanism ⚙️️⚙
  // It's responsible it to filling the watch progress as long as it's ticking.
  StreamSubscription<int>? _tickerSubscription;

  // Each story watch duration in milliseconds.
  final int _storyDuration;

  // Stories count.
  final int _storiesLength;

  // The source of each story progress.
  final Ticker _ticker;

  // Creates a new repeating timer.
  //
  // Firing IntroductionTicked repeatedly with duration intervals until
  // canceled with the cancel function.
  void _onStarted(_, Emitter<IntroductionState> emit) {
    _tickerSubscription?.cancel();

    _tickerSubscription = _ticker
        .tick(duration: _storyDuration, ticks: _completeWatchProgress)
        .listen((progress) => add(_IntroductionTicked(progress)))
      ..onDone(() => add(const IntroductionNext()));
  }

  void _onPause(_, Emitter<IntroductionState> emit) {
    
    _tickerSubscription?.pause();
    print("_______Paused ${_tickerSubscription?.isPaused}");
  }

  void _onResumed(_, Emitter<IntroductionState> emit) {
    final watchProgress = List<int>.from(state.watchProgress);
    final currentStoryIndex = state.index;
    emit(IntroductionRunInProgress(currentStoryIndex, watchProgress));
    _tickerSubscription?.resume();

    print("_______Resumed ${_tickerSubscription?.isPaused}");
  }

  // Emits IntroductionRunInProgress with current story watch progress updates.
  Future<void> _onTicked(
    _IntroductionTicked event,
    Emitter<IntroductionState> emit,
  ) async {
    final watchProgress = List<int>.from(state.watchProgress);
    final currentStoryIndex = state.index;

    watchProgress[currentStoryIndex] = event.progress;

    emit(IntroductionRunInProgress(currentStoryIndex, watchProgress));
  }

  // Emit IntroductionRunInProgress to complete
  // the current story watch progress,
  // and
  // either start the next story if remaining
  // or Emit IntroductionRunComplete if it was the last one.
  void _onNext(_, Emitter<IntroductionState> emit) {
    final currentStoryIndex = state.index;
    final watchProgress = List<int>.from(state.watchProgress);

    watchProgress[currentStoryIndex] = _completeWatchProgress;
    emit(IntroductionRunInProgress(currentStoryIndex, watchProgress));

    // A remaining story next.
    if (currentStoryIndex < _storiesLength - 1) {
      emit(IntroductionRunInProgress(currentStoryIndex + 1, watchProgress));

      add(const IntroductionStarted());

      return;
    }

    _tickerSubscription?.cancel();
    emit(const IntroductionRunComplete());
  }

  // Ignores the event if the current story is the first one!
  // And emits IntroductionRunInProgress with retested progress of
  // the current and the previous story.
  // Adding to that,
  // setting the index of the previous story as the current index.
  // Finally emits IntroductionStarted to start the watch progress.
  void _onPrevious(_, Emitter<IntroductionState> emit) {
    final currentStoryIndex = state.index;
    final storiesWatchProgress = List<int>.from(state.watchProgress);

    // Ignore event when current story is the first one.
    if (currentStoryIndex == 0) return;

    // Return previous and current story watch progress back to zero.
    storiesWatchProgress[currentStoryIndex - 1] = 0;
    storiesWatchProgress[currentStoryIndex] = 0;

    // Return to the previous story.
    emit(
      IntroductionRunInProgress(currentStoryIndex - 1, storiesWatchProgress),
    );

    add(const IntroductionStarted());
  }

  @override
  void onChange(Change<IntroductionState> change) {
    super.onChange(change);
    debugPrint(change.toString());
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}

/// [Ticker] exposes a [tick] method to emit values periodically.
@visibleForTesting
class Ticker {
  /// Emits a new `int` up to [ticks] in a given [duration] (in milliseconds).
  ///
  /// Begins with 1 until reach the [ticks] value.
  Stream<int> tick({int duration = 1000, int ticks = 100}) {
    return Stream.periodic(
      Duration(milliseconds: duration ~/ ticks),
      (x) => x + 1,
    ).take(ticks);
  }
}
