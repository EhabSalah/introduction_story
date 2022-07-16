part of "story_introduction_screen.dart";

class WatchProgressBars extends StatelessWidget {
  final List<double> percentWatched;

  const WatchProgressBars({Key? key, required this.percentWatched})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 1.0;

    return Row(
      children: percentWatched.mapIndexed(
        (index, element) {
          final isFirst = index == 0;
          final isLast = index == percentWatched.length - 1;

          EdgeInsetsGeometry padding;
          if (isFirst) {
            padding = const EdgeInsetsDirectional.only(
                start: horizontalPadding / 2, end: horizontalPadding);
          } else if (isLast) {
            padding = const EdgeInsetsDirectional.only(
                start: horizontalPadding, end: horizontalPadding / 2);
          } else {
            padding = const EdgeInsets.symmetric(horizontal: horizontalPadding);
          }

          return Expanded(
            child: Padding(
              padding: padding,
              child: _MyProgressBar(percentWatched: percentWatched[index]),
            ),
          );
        },
      ).toList(),
    );
  }
}

class _MyProgressBar extends StatelessWidget {
  final double percentWatched;

  const _MyProgressBar({Key? key, required this.percentWatched})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: percentWatched,
      minHeight: 2,
      color: Colors.white,
      backgroundColor: Colors.grey[200]?.withOpacity(.5),
    );
  }
}
