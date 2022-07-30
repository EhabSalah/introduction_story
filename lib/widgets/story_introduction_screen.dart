import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  /// Each story watch duration.
  final List<Story> stories;

  /// Each story watch duration in milliseconds.
  final int duration;

  /// Drag vertically to dismiss.
  final bool isDismissible;

  StoryIntroductionProps({
    required this.stories,
    required this.duration,
    this.isDismissible = false,
  });
}

class StoryIntroductionScreen extends StatelessWidget {
  final StoryIntroductionProps _props;

  const StoryIntroductionScreen(StoryIntroductionProps props, {Key? key})
      : _props = props,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _prefetchImages(_props.stories, context);

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

            final storyTheme =
                _props.stories[state.currentStoryIndex].storyThemeMode;

            final backgroundColor =
                _props.stories[state.currentStoryIndex].backgroundColor;

            final foreground =
                _props.stories[state.currentStoryIndex].foreground;

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                // We didn't change the statusbar brightness in Android because of this issue
                // https://stackoverflow.com/questions/62101879/how-to-revert-status-bar-to-its-default-values-after-using-annotatedregion

                // Only for iOS.
                statusBarBrightness:
                    Platform.isIOS ? storyTheme.brightness : null,
              ),
              child: Stack(
                children: [
                  // Background
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      image: imagePath != null
                          ? DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.fill,
                            )
                          : null,
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          top: 60.0,
                          start: 18.0,
                          end: 18.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Progress bars
                            WatchProgressBars(
                              percentWatched: state.storiesWatchProgress,
                              color: storyTheme.foregroundColor,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      if (foreground != null) foreground
                    ],
                  ),
                ],
              ),
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
              key: UniqueKey(),
              direction: DismissDirection.vertical,
              onDismissed: (_) => Navigator.of(context).pop(),
              child: scaffold,
            ),
    );
  }
}

/// Prefetch images into the image cache.
/// If the image is later used, it will probably be loaded faster.
void _prefetchImages(List<Story> stories, BuildContext context) {
  final imagePaths = stories.map((s) => s.imagePath);

  for (var imagePath in imagePaths) {
    if (imagePath != null) precacheImage(AssetImage(imagePath), context);
  }
}
