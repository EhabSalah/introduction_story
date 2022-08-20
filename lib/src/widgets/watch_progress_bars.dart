// coverage:ignore-file
part of 'story_introduction_screen.dart';

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
