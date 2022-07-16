part of 'story_introduction_screen.dart';

class _Gestures extends StatelessWidget {
  final void Function() onFirstHalfPressed;
  final void Function() onSecondHalfPressed;
  final void Function() onLongPress;
  final void Function() onLongPressUp;

  const _Gestures({
    Key? key,
    required this.onFirstHalfPressed,
    required this.onSecondHalfPressed,
    required this.onLongPress,
    required this.onLongPressUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onFirstHalfPressed(),
            onLongPress: () => onLongPress(),
            onLongPressUp: () => onLongPressUp(),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onSecondHalfPressed(),
            onLongPress: () => onLongPress(),
            onLongPressUp: () => onLongPressUp(),
          ),
        ),
      ],
    );
  }
}
