import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/introduction_bloc.dart';
import '../story.dart';

part 'gestures.dart';

part 'watch_progress_bars.dart';

class StoryIntroduction extends StatelessWidget {
  /// Each story watch duration.
  final List<Story> stories;

  /// Each story watch duration in milliseconds.
  final int duration;

  /// Drag vertically to dismiss.
  final bool isDismissible;

  StoryIntroduction({
    Key? key,
    required this.stories,
    required this.duration,
    this.isDismissible = false,
  })  : assert(stories.isNotEmpty, 'Stories count should be more than zero!'),
        assert(duration >= 1000, 'Story duration should be >= 1 second.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _prefetchImages(stories, context);

    final scaffold = Scaffold(
      body: BlocProvider<IntroductionBloc>(
        create: (_) => IntroductionBloc(
          storyDuration: duration,
          storiesLength: stories.length,
        )..add(const IntroductionStarted()),
        child: BlocConsumer<IntroductionBloc, IntroductionState>(
          listener: (_, state) {
            if (state is IntroductionRunComplete) Navigator.pop(context);
          },
          buildWhen: (_, current) => current is IntroductionRunInProgress,
          builder: (context, state) {
            final imagePath = stories[state.index].imagePath;

            final storyTheme = stories[state.index].storyThemeMode;

            final backgroundColor = stories[state.index].backgroundColor;

            final foreground = stories[state.index].foreground;

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
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
                          .read<IntroductionBloc>()
                          .add(const IntroductionPrevious());
                    },
                    onSecondHalfPressed: () {
                      context
                          .read<IntroductionBloc>()
                          .add(const IntroductionNext());
                    },
                    onLongPress: () {
                      context
                          .read<IntroductionBloc>()
                          .add(const IntroductionPause());
                    },
                    onLongPressUp: () {
                      context
                          .read<IntroductionBloc>()
                          .add(const IntroductionResume());
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
                              progresses: state.watchProgress
                                  .map((e) => e / 100)
                                  .toList(),
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

    return !isDismissible
        ? scaffold
        : Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.vertical,
            onDismissed: (_) => Navigator.of(context).pop(),
            child: scaffold,
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
