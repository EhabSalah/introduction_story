// coverage:ignore-file

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_story/src/bloc/introduction_bloc.dart';
import 'package:introduction_story/src/model/story.dart';

/// {@template introduction_story_screen}
/// A screen which build for introducing something in the form of stories.
/// {@endtemplate}
class IntroductionStoryScreen extends StatelessWidget {
  /// {@macros introduction_story_screen}
  IntroductionStoryScreen({
    super.key,
    required this.stories,
    this.duration = 2000,
    this.isDismissible = false,
    this.hideSkipButton = false,
  })  : assert(stories.isNotEmpty, 'Stories count should be more than zero!'),
        assert(
          duration >= minimumStoryDuration,
          'Story duration should be >= $minimumStoryDuration ms.',
        ),
        assert(
          isDismissible || !hideSkipButton,
          'Screen should at least swiped to be dismissed '
          'or gives the ability to be closed by showing the close button.',
        );

  /// Each story watch duration.
  final List<Story> stories;

  /// Each story watch duration in milliseconds.
  ///
  /// @Default `2000` milliseconds.
  final int duration;

  /// Drag vertically to dismiss.
  ///
  /// @Default `false`
  final bool isDismissible;

  /// Show/hide close button.
  ///
  /// @Default `false`
  final bool hideSkipButton;

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
            final story = stories[state.index];
            final imagePath = story.imagePath;
            final decoration = story.decoration;

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                // Only for iOS.
                statusBarBrightness:
                    Platform.isIOS ? decoration.storyTheme.brightness : null,
              ),
              child: Stack(
                children: [
                  // Background
                  // ignore: use_decorated_box
                  Container(
                    decoration: BoxDecoration(
                      color: decoration.backgroundColor,
                      image: imagePath == null
                          ? null
                          : DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.fill,
                            ),
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
                  _Foreground(
                    story,
                    state.watchProgress,
                    hideCloseButton: hideSkipButton,
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

// Prefetch images into the image cache.
// If the image is later used, it will probably be loaded faster.
void _prefetchImages(List<Story> stories, BuildContext context) {
  final imagePaths = stories.map((s) => s.imagePath);

  for (final imagePath in imagePaths) {
    if (imagePath != null) precacheImage(AssetImage(imagePath), context);
  }
}

class _Foreground extends StatelessWidget {
  const _Foreground(
    this.story,
    this.watchProgress, {
    required this.hideCloseButton,
  });

  final List<int> watchProgress;
  final bool hideCloseButton;

  final Story story;

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 18.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 60,
            start: horizontalPadding,
            end: horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bars
              _WatchProgressBars(
                progresses: watchProgress
                    .map((e) => e / completeWatchProgress)
                    .toList(),
                color: story.decoration.storyTheme.foregroundColor,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: horizontalPadding,
          ),
          child: Row(
            children: [
              // Story name.
              Expanded(
                child: Text(
                  story.name,
                  style: story.decoration.nameTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
              ),
              const Spacer(),

              // Skip button.
              SizedBox(
                height: 44,
                width: 60,
                child: Visibility(
                  visible: !hideCloseButton,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: story.decoration.storyTheme.foregroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Story title.
                Flexible(
                  child: Text(
                    story.title,
                    style: story.decoration.titleTextStyle,
                    overflow: TextOverflow.fade,
                  ),
                ),

                const SizedBox(height: 8),

                // Story description.
                Flexible(
                  child: Text(
                    story.description,
                    style: story.decoration.descriptionTextStyle,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Gestures extends StatelessWidget {
  const _Gestures({
    required this.onFirstHalfPressed,
    required this.onSecondHalfPressed,
    required this.onLongPress,
    required this.onLongPressUp,
  });

  final void Function() onFirstHalfPressed;
  final void Function() onSecondHalfPressed;
  final void Function() onLongPress;
  final void Function() onLongPressUp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onFirstHalfPressed,
            onLongPress: onLongPress,
            onLongPressUp: onLongPressUp,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onSecondHalfPressed,
            onLongPress: onLongPress,
            onLongPressUp: onLongPressUp,
          ),
        ),
      ],
    );
  }
}

class _WatchProgressBars extends StatelessWidget {
  const _WatchProgressBars({required this.progresses, required this.color});

  // Progress bars progress.
  final List<double> progresses;

  // Color of the progress bars.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ProgressIndicatorTheme(
      data: ProgressIndicatorThemeData(
        color: color,
        linearTrackColor: color.withOpacity(.5),
        linearMinHeight: 2,
      ),
      child: Row(
        children: progresses.mapIndexed(
          (index, progress) {
            final padding = _getPadding(
              index: index,
              length: progresses.length,
            );

            return Expanded(
              child: Padding(
                padding: padding,
                child: LinearProgressIndicator(value: progress),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  EdgeInsetsGeometry _getPadding({required int index, required int length}) {
    const horizontalPadding = 1.0;

    final isFirst = index == 0;
    final isLast = index == progresses.length - 1;

    if (isFirst) {
      return const EdgeInsetsDirectional.only(end: horizontalPadding);
    } else if (isLast) {
      return const EdgeInsetsDirectional.only(start: horizontalPadding);
    } else {
      return const EdgeInsets.symmetric(horizontal: horizontalPadding);
    }
  }
}
