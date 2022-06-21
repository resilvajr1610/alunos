import '../utils/export.dart';

class AddButtom extends StatelessWidget {
  final onPressed;

  AddButtom({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 50,
      onPressed: onPressed,
      icon: Icon(
        Icons.add_circle_outlined,
        color: PaletteColor.primaryColor,
        size: 50,
      ),
    );
  }
}
