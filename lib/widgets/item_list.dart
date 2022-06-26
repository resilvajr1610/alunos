import '../utils/export.dart';

class ItemList extends StatelessWidget {
  final text;
  final onTapDelete;
  final onTapEdit;
  final onPressedPDF;

  ItemList({
  required this.text,
  required this.onTapDelete,
  required this.onTapEdit,
  this.onPressedPDF=null,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        onTapDelete!=null?Divider():Container(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
            onPressedPDF==null
                ?Container(width: width*0.1)
                :Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    onPressed: onPressedPDF,
                    icon: Icon(Icons.picture_as_pdf,color: PaletteColor.primaryColor,size: 30)
              ),
                ),
              Container(
                width: width*0.55,
                child: TextCustom(text: text,color: PaletteColor.greyText,size: 16.0,)
              ),
              Spacer(),
              onTapDelete!=null?IconButton(
                onPressed: onTapEdit,
                icon: Icon(Icons.edit,color: PaletteColor.blueLight,size: 30),
              ):Container(),
              SizedBox(width: width*0.05),
              onTapDelete!=null?IconButton(
                onPressed: onTapDelete,
                icon: Icon(Icons.delete_forever,color: PaletteColor.red,size: 30,)
              ):Container(),
            ],
          ),
        ),
        onTapDelete==null?Divider():Container(),
      ],
    );
  }
}
