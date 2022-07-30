part of "story_introduction_screen.dart";

class WatchProgressBars extends StatelessWidget {
  final List<double> percentWatched;
  final Color color;

  const WatchProgressBars(
      {Key? key, required this.percentWatched, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressIndicatorTheme(
      data: ProgressIndicatorThemeData(
        color: color,
        linearTrackColor: color.withOpacity(.5),
        linearMinHeight: 2,
      ),
      child: Row(
        children: percentWatched.mapIndexed(
          (index, element) {
            final padding =
                _getPadding(index: index, length: percentWatched.length);

            return Expanded(
              child: Padding(
                padding: padding,
                child: LinearProgressIndicator(value: percentWatched[index]),
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
    final isLast = index == percentWatched.length - 1;

    if (isFirst) {
      return const EdgeInsetsDirectional.only(start: 0, end: horizontalPadding);
    } else if (isLast) {
      return const EdgeInsetsDirectional.only(start: horizontalPadding, end: 0);
    } else {
      return const EdgeInsets.symmetric(horizontal: horizontalPadding);
    }
  }
}
