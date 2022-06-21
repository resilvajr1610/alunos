import '../utils/export.dart';

class CardCustom extends StatelessWidget {

  final text;
  final textColor;
  final onPressed;
  final background;

  CardCustom({
    required this.text,
    required this.onPressed,
    this.background = PaletteColor.greyLight,
    this.textColor = PaletteColor.greyText
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        color:background,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: width*0.8,
          height: 100.0,
          child: TextButton(
            child: TextCustom(text: text,color: textColor,),
            onPressed: this.onPressed,
          ),
        ),
      ),
    );
  }
}
