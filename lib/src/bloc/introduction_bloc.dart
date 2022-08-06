import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'introduction_event.dart';

part 'introduction_state.dart';

class IntroductionBloc extends Bloc<IntroductionEvent, IntroductionState> {
  final int _completeStoryProgress;

  /// [_tickerSubscription] is the source of move for the whole mechanism ⚙️️⚙
  /// It's responsible it to filling the watch progress as long as it's ticking.
  StreamSubscription<int>? _tickerSubscription;

  /// Each story watch duration in milliseconds.
  final int _storyDuration;

  final int _storiesLength;

  final Ticker _ticker;

  IntroductionBloc({
    required int storiesLength,
    int completeStoryProgress = 100,
    int storyDuration = 1000,
    Ticker? ticker,
  })  : _storiesLength = storiesLength,
        _storyDuration = storyDuration,
        _completeStoryProgress = completeStoryProgress,
        _ticker = ticker ?? const Ticker(),
        assert(storiesLength > 0, 'Stories count should be more than zero!'),
        assert(completeStoryProgress > 100, ''),
        assert(storyDuration >= 1000, 'Story duration should be >= 1 second.'),
        super(IntroductionInitial(0, List.generate(storiesLength, (_) => 0))) {
    on<IntroductionStarted>(_onStarted);

    on<IntroductionTicked>(_onTicked);

    on<IntroductionPrevious>(_onPrevious);

    on<IntroductionNext>(_onNext);

    on<IntroductionPause>(_onPause);

    on<IntroductionResume>(_onResumed);
  }

  /// [_onStarted] creates a new repeating timer.
  ///
  /// Firing [IntroductionTicked] event repeatedly with [duration] intervals until
  /// canceled with the [cancel] function.
  void _onStarted(_, Emitter<IntroductionState> emit) {
    _tickerSubscription?.cancel();

    _tickerSubscription = _ticker
        .tick(duration: _storyDuration, ticks: _completeStoryProgress)
        .listen((progress) => add(IntroductionTicked(progress)))
      ..onDone(() => add(const IntroductionNext()));
  }

  void _onPause(_, Emitter<IntroductionState> emit) {
    _tickerSubscription?.pause();
  }

  void _onResumed(_, Emitter<IntroductionState> emit) {
    _tickerSubscription?.resume();
  }

  void _onTicked(IntroductionTicked event, emit) async {
    final watchProgress = List<int>.from(state.watchProgress);
    final currentStoryIndex = state.index;

    watchProgress[currentStoryIndex] = event.progress;

    emit(IntroductionRunInProgress(currentStoryIndex, watchProgress));
  }

  void _onNext(_, Emitter<IntroductionState> emit) {
    final currentStoryIndex = state.index;
    final watchProgress = List<int>.from(state.watchProgress);

    watchProgress[currentStoryIndex] = _completeStoryProgress;
    emit(IntroductionRunInProgress(currentStoryIndex, watchProgress));

    // When there are remaining stories next.
    if (currentStoryIndex < _storiesLength - 1) {
      emit(IntroductionRunInProgress(currentStoryIndex + 1, watchProgress));

      add(const IntroductionStarted());

      return;
    }

    _tickerSubscription?.cancel();
    emit(const IntroductionRunComplete());
  }

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

@visibleForTesting
class Ticker {
  const Ticker();

  Stream<int> tick({int duration = 1000, int ticks = 100}) {
    return Stream.periodic(
        Duration(milliseconds: duration ~/ ticks), (x) => x + 1).take(ticks);
  }
}
