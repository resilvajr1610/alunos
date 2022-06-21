import '../utils/export.dart';

class ButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double size;
  final Color colorButton;
  final Color colorText;
  final Color colorBorder;
  final widthCustom;
  final heightCustom;

  ButtonCustom({
    required this.onPressed,
    required this.text,
    this.size = 14.0,
    this.colorButton = PaletteColor.primaryColor,
    this.colorText = PaletteColor.white,
    this.colorBorder = PaletteColor.primaryColor,
    this.widthCustom = 0.6,
    this.heightCustom = 0.06
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: this.colorButton,
            minimumSize: Size(widthCustom*width, heightCustom*height),
            side: BorderSide(width: 3,color: colorBorder),
          ),
        onPressed: onPressed,
        child: TextCustom(
          text: 'Entrar',
          color: colorText,
        )
    );
  }
}
