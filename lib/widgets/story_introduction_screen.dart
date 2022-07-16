import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../story.dart';

part '../bloc/story_introduction_bloc.dart';

part '../bloc/story_introduction_event.dart';

part '../bloc/story_introduction_state.dart';

part 'gestures.dart';

part 'watch_progress_bars.dart';

/// [StoryIntroductionProps] represents the required properties
/// for [StoryIntroductionScreen] widget to be rendered.
class StoryIntroductionProps {
  /// Feature name
  final String featureName;

  /// Each story watch duration.
  final List<Story> stories;

  /// Each story watch duration in milliseconds.
  final int duration;

  /// Drag vertically to dismiss.
  final bool isDismissible;

  StoryIntroductionProps({
    required this.featureName,
    required this.stories,
    required this.duration,
    this.isDismissible = false,
  });
}

class StoryIntroductionScreen extends StatelessWidget {
  static const _contentHorizontalPadding = 18.0;

  final StoryIntroductionProps _props;

  const StoryIntroductionScreen(StoryIntroductionProps props, {Key? key})
      : _props = props,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      body: BlocProvider<_StoryIntroductionBloc>(
        create: (_) => _StoryIntroductionBloc(
          storyDuration: _props.duration,
          storiesCount: _props.stories.length,
        )..add(_Start()),
        child: BlocConsumer<_StoryIntroductionBloc, _StoryIntroductionState>(
          listener: (_, state) {
            if (state is _End) Navigator.pop(context);
          },
          builder: (context, state) {
            final imagePath = _props.stories[state.currentStoryIndex].imagePath;
            return Stack(
              children: [
                // Background
                Container(
                  decoration: BoxDecoration(
                    color:
                        _props.stories[state.currentStoryIndex].backgroundColor,
                    image: imagePath == null
                        ? null
                        : DecorationImage(
                            image: AssetImage(imagePath), fit: BoxFit.fill),
                  ),
                ),

                // Gestures
                _Gestures(
                  onFirstHalfPressed: () {
                    context
                        .read<_StoryIntroductionBloc>()
                        .add(_PreviousStory());
                  },
                  onSecondHalfPressed: () {
                    context.read<_StoryIntroductionBloc>().add(_NextStory());
                  },
                  onLongPress: () {
                    context.read<_StoryIntroductionBloc>().add(_Pause());
                  },
                  onLongPressUp: () {
                    context.read<_StoryIntroductionBloc>().add(_Continue());
                  },
                ),

                // Foreground
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 60,
                    start: StoryIntroductionScreen._contentHorizontalPadding,
                    end: StoryIntroductionScreen._contentHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress bars
                      WatchProgressBars(
                        percentWatched: state.storiesWatchProgress,
                      ),
                      const SizedBox(height: 16),

                      // Feature name and Skip button
                      _FeatureNameAndSkip(_props.featureName),

                      const SizedBox(height: 2),

                      // Story Title
                      Text(
                        _props.stories[state.currentStoryIndex].title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      // Story Description
                      Text(
                        _props.stories[state.currentStoryIndex].description,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    return MediaQuery(
      // Ignore the OS changes in text size.
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),

      child: !_props.isDismissible
          ? scaffold
          : Dismissible(
              key: const Key('_'),
              direction: DismissDirection.vertical,
              onDismissed: (_) => Navigator.of(context).pop(),
              child: scaffold,
            ),
    );
  }
}

class _FeatureNameAndSkip extends StatelessWidget {
  final String name;

  const _FeatureNameAndSkip(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.fade)),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsetsDirectional.only(start: 16, bottom: 8),
            child: const Icon(Icons.clear, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
