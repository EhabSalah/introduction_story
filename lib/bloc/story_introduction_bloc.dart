part of '../widgets/story_introduction_screen.dart';

class _StoryIntroductionBloc
    extends Bloc<_StoryIntroductionEvent, _StoryIntroductionState> {
  final completeWatchProgressValue = 1.0;

  /// [_storyTimer] is the source of move for the whole mechanism ⚙️️⚙
  /// It's responsible it to filling the watch progress as long as it's ticking.
  late Timer? _storyTimer;

  /// Each story watch duration in milliseconds.
  final int _storyDuration;

  final int _storiesCount;

  _StoryIntroductionBloc({
    required int storiesCount,
    required int storyDuration,
  })  : _storiesCount = storiesCount,
        _storyDuration = storyDuration,
        assert(storiesCount > 0, 'Stories count should be more than zero!'),
        assert(storyDuration >= 1000, 'Story duration should be >= 1 second.'),
        super(
          _WatchProgress(
            currentStoryIndex: 0,
            watchProgress: List.generate(storiesCount, (index) => 0),
          ),
        ) {
    on<_Start>(_onStart);

    on<_TimerTick>(_onTimerTick);

    on<_PreviousStory>(_onPreviousStory);

    on<_NextStory>(_onNextPage);

    on<_Pause>(_onPause);

    on<_Continue>(_onContinue);
  }

  /// [_onStart] creates a new repeating timer.
  ///
  /// Firing [_TimerTick] event repeatedly with [duration] intervals until
  /// canceled with the [cancel] function.
  void _onStart(_Start _, Emitter<_StoryIntroductionState> emit) {
    final duration = _storyDuration ~/ 100;

    _storyTimer = Timer.periodic(
      Duration(milliseconds: duration),
      (_) => add(_TimerTick()),
    );
  }

  void _onPause(_Pause _, Emitter<_StoryIntroductionState> emit) =>
      _storyTimer?.cancel();

  void _onContinue(_Continue _, Emitter<_StoryIntroductionState> emit) =>
      add(_Start());

  void _onTimerTick(_TimerTick _, emit) async {
    const watchIncrementFactor = 0.01;

    final watchProgress = state.storiesWatchProgress;
    final currentStoryIndex = state.currentStoryIndex;

    // Add watchIncrementFactor to the watchProgress as long as it's below 1.
    if (watchProgress[currentStoryIndex] + watchIncrementFactor <
        completeWatchProgressValue) {
      watchProgress[currentStoryIndex] += watchIncrementFactor;

      emit(_WatchProgress(
        currentStoryIndex: currentStoryIndex,
        watchProgress: watchProgress,
      ));
    }

    // Set progress to the fullyWatchedValue, cancel timer and start next story of finish 🤷🏻‍
    else {
      watchProgress[currentStoryIndex] = completeWatchProgressValue;
      emit(_WatchProgress(
        currentStoryIndex: currentStoryIndex,
        watchProgress: watchProgress,
      ));

      _storyTimer?.cancel();

      // Move to next story as long as currentStoryIndex isn't the last one.
      if (currentStoryIndex < _storiesCount - 1) {
        emit(_WatchProgress(
          currentStoryIndex: currentStoryIndex + 1,
          watchProgress: watchProgress,
        ));

        // restart story timer
        add(_Start());
      }

      // If we are finishing the last story then emit _End 🏁
      else {
        emit(_End(
          currentStoryIndex: currentStoryIndex,
          watchProgress: watchProgress,
        ));
      }
    }
  }

  void _onPreviousStory(
      _PreviousStory _, Emitter<_StoryIntroductionState> emit) {
    final currentStoryIndex = state.currentStoryIndex;
    final storiesWatchProgress = state.storiesWatchProgress;

    // Ignore event when current story is the first one.
    if (currentStoryIndex == 0) return;

    // Return previous and current story watch progress back to zero.
    storiesWatchProgress[currentStoryIndex - 1] = 0;
    storiesWatchProgress[currentStoryIndex] = 0;

    // Return to the previous story.
    emit(_WatchProgress(
      currentStoryIndex: currentStoryIndex - 1,
      watchProgress: storiesWatchProgress,
    ));
  }

  void _onNextPage(_NextStory _, Emitter<_StoryIntroductionState> emit) {
    final currentStoryIndex = state.currentStoryIndex;
    final storiesWatchProgress = state.storiesWatchProgress;

    // When there are remaining stories next.
    if (currentStoryIndex < _storiesCount - 1) {
      // Complete current story watch progress.
      storiesWatchProgress[currentStoryIndex] = completeWatchProgressValue;

      // Move to next story.
      emit(_WatchProgress(
        currentStoryIndex: currentStoryIndex + 1,
        watchProgress: storiesWatchProgress,
      ));
    }

    // When currentStoryIndex isn't the last one, just complete it's watch progress.
    else {
      storiesWatchProgress[currentStoryIndex] = completeWatchProgressValue;

      emit(_WatchProgress(
        currentStoryIndex: currentStoryIndex,
        watchProgress: storiesWatchProgress,
      ));
    }
  }

  @override
  Future<void> close() {
    _storyTimer?.cancel();
    return super.close();
  }
}
