part of '../bloc/introduction_bloc.dart';

@immutable
abstract class IntroductionState extends Equatable {
  final int index;
  final List<int> watchProgress;

  const IntroductionState(this.index, this.watchProgress);

  get progressOfCurrentIndex => watchProgress[index];

  @override
  List<Object?> get props => [index, watchProgress];
}

class IntroductionInitial extends IntroductionState {
  const IntroductionInitial(int index, List<int> watchProgress)
      : super(index, watchProgress);

  @override
  String toString() =>
      'IntroductionInitial { index: $index, watchProgress: $watchProgress }';
}

class IntroductionRunInProgress extends IntroductionState {
  const IntroductionRunInProgress(int index, List<int> watchProgress)
      : super(index, watchProgress);

  @override
  String toString() =>
      'IntroductionRunInProgress { index: $index, watchProgress: $watchProgress }';
}

class IntroductionRunComplete extends IntroductionState {
  const IntroductionRunComplete() : super(0, const []);

  @override
  String toString() =>
      'IntroductionRunComplete { index: $index, watchProgress: $watchProgress }';
}
