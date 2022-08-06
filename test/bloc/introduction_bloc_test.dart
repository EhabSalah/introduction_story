import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:story_introduction/src/bloc/introduction_bloc.dart';
import 'package:test/test.dart';

class MockTicker extends Mock implements Ticker {}

void main() {
  group('Ticker', () {
    const ticker = Ticker();

    test('ticker emits 3 ticks from 1-3', () {
      expect(ticker.tick(ticks: 3), emitsInOrder([1, 2, 3, emitsDone]));
    });
  });

  group(
    'StoryIntroductionBloc',
    () {
      const completeProgress = 3;

      late Ticker ticker;

      setUp(() {
        ticker = MockTicker();

        when(() => ticker.tick(
              ticks: any(named: "ticks"),
              duration: any(named: "duration"),
            )).thenAnswer(
          (_) => Stream<int>.fromIterable(
            List.generate(completeProgress, (index) => index + 1), // [1,2,3]
          ),
        );
      });

      test('initial state is IntroductionInitial([0,0]])', () {
        expect(
          IntroductionBloc(storiesLength: 2, ticker: ticker).state,
          const IntroductionInitial(0, [0, 0]),
        );
      });

      blocTest<IntroductionBloc, IntroductionState>(
        'emits IntroductionRunInProgress 3 times followed by '
        'IntroductionRunComplete when the completed story is the last one',
        build: () => IntroductionBloc(
          storiesLength: 1,
          ticker: ticker,
          completeStoryProgress: completeProgress,
        ),
        act: (bloc) => bloc.add(const IntroductionStarted()),
        expect: () => <IntroductionState>[
          const IntroductionRunInProgress(0, [1]),
          const IntroductionRunInProgress(0, [2]),
          const IntroductionRunInProgress(0, [3]),
          const IntroductionRunComplete(),
        ],
        verify: (_) =>
            verify(() => ticker.tick(ticks: completeProgress)).called(1),
      );

      blocTest<IntroductionBloc, IntroductionState>(
        'emits IntroductionRunInProgress 6 times 3 of which with index 0,'
        ' and the other 3 with the index 1.'
        'Followed by IntroductionRunComplete',
        build: () => IntroductionBloc(
          storiesLength: 2,
          ticker: ticker,
          completeStoryProgress: completeProgress,
        ),
        act: (bloc) => bloc.add(const IntroductionStarted()),
        expect: () => <IntroductionState>[
          const IntroductionRunInProgress(0, [1, 0]),
          const IntroductionRunInProgress(0, [2, 0]),
          const IntroductionRunInProgress(0, [3, 0]),
          const IntroductionRunInProgress(1, [3, 0]),
          const IntroductionRunInProgress(1, [3, 1]),
          const IntroductionRunInProgress(1, [3, 2]),
          const IntroductionRunInProgress(1, [3, 3]),
          const IntroductionRunComplete(),
        ],
        verify: (_) =>
            verify(() => ticker.tick(ticks: completeProgress)).called(2),
      );

      blocTest<IntroductionBloc, IntroductionState>(
        'IntroductionPrevious reset the current and last story progress and decrements the current index by 1',
        build: () => IntroductionBloc(
            storiesLength: 2,
            ticker: ticker,
            completeStoryProgress: completeProgress),
        seed: () => const IntroductionRunInProgress(1, [3, 2]),
        act: (bloc) => bloc.add(const IntroductionPrevious()),
        expect: () => <IntroductionState>[
          const IntroductionRunInProgress(0, [0, 0]),
          const IntroductionRunInProgress(0, [1, 0]),
          const IntroductionRunInProgress(0, [2, 0]),
          const IntroductionRunInProgress(0, [3, 0]),
          const IntroductionRunInProgress(1, [3, 0]),
          const IntroductionRunInProgress(1, [3, 1]),
          const IntroductionRunInProgress(1, [3, 2]),
          const IntroductionRunInProgress(1, [3, 3]),
          const IntroductionRunComplete(),
        ],
        verify: (_) =>
            verify(() => ticker.tick(ticks: completeProgress)).called(2),
      );

      blocTest<IntroductionBloc, IntroductionState>(
        'IntroductionPrevious emits nothing if the current index is the first one',
        build: () => IntroductionBloc(storiesLength: 2, ticker: ticker),
        seed: () => const IntroductionRunInProgress(0, [2, 0]),
        act: (bloc) => bloc.add(const IntroductionPrevious()),
        expect: () => <IntroductionState>[],
        verify: (_) => verifyNever(() => ticker.tick()),
      );

      blocTest<IntroductionBloc, IntroductionState>(
        'NextIntroductionStory emits IntroductionRunInProgress with complete currentIndex',
        build: () => IntroductionBloc(
            storiesLength: 2,
            ticker: ticker,
            completeStoryProgress: completeProgress),
        seed: () => const IntroductionRunInProgress(0, [1, 0]),
        act: (bloc) => bloc.add(const IntroductionNext()),
        expect: () => <IntroductionState>[
          const IntroductionRunInProgress(0, [3, 0]),
          const IntroductionRunInProgress(1, [3, 0]),
          const IntroductionRunInProgress(1, [3, 1]),
          const IntroductionRunInProgress(1, [3, 2]),
          const IntroductionRunInProgress(1, [3, 3]),
          const IntroductionRunComplete(),
        ],
        verify: (_) =>
            verify(() => ticker.tick(ticks: completeProgress)).called(1),
      );

      blocTest<IntroductionBloc, IntroductionState>(
        'NextIntroductionStory completes the into if the running story is  the last one',
        build: () => IntroductionBloc(
            storiesLength: 2,
            ticker: ticker,
            completeStoryProgress: completeProgress),
        seed: () => const IntroductionRunInProgress(1, [3, 1]),
        act: (bloc) => bloc.add(const IntroductionNext()),
        expect: () => <IntroductionState>[
          const IntroductionRunInProgress(1, [3, 3]),
          const IntroductionRunComplete(),
        ],
        verify: (_) => verifyNever(() => ticker.tick(ticks: completeProgress)),
      );
    },
  );
}
