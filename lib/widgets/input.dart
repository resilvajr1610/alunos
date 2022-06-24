import '../utils/export.dart';

class Input extends StatelessWidget {

  final controller;
  final hint;
  final fonts;
  final keyboardType;
  final widthCustom;
  final sizeIcon;
  final icons;
  final colorBorder;
  final colorIcon;
  final background;
  final obscure;
  final maxline;
  final enable;
  VoidCallback? onTap=(){};
  List <TextInputFormatter>? inputFormatters=[];

  Input({
    required this.controller,
    required this.hint,
    this.fonts = 16.0,
    this.keyboardType = TextInputType.text,
    this.widthCustom = 0.6,
    this.maxline = 1,
    this.sizeIcon = 0.0,
    this.icons = Icons.visibility_off,
    this.colorBorder = PaletteColor.white,
    this.colorIcon = PaletteColor.greyLight,
    this.background = PaletteColor.greyLight,
    this.obscure = false,
    this.onTap,
    this.enable = true,
    this.inputFormatters
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.topCenter,
      width: width*widthCustom,
      height: 43,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: colorBorder)
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              enabled: enable,
              obscureText: obscure,
              controller: controller,
              textAlign: TextAlign.start,
              keyboardType: keyboardType,
              textAlignVertical: TextAlignVertical.center,
              maxLines: maxline,
              inputFormatters: inputFormatters,
              style: TextStyle(
                color: Colors.black54,
                fontSize: fonts,
                fontFamily: 'Nunito'
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.hint,
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: this.fonts,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(obscure?Icons.visibility:icons,size: sizeIcon,color: colorIcon)
          ),
        ],
      ),
    );
  }
}
