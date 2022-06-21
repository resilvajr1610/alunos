import '../utils/export.dart';

class ItemList extends StatelessWidget {
  final text;
  final onTapDelete;
  final onTapEdit;

  ItemList({
  required this.text,
  required this.onTapDelete,
  required this.onTapEdit,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SizedBox(width: width*0.1),
              Container(
                width: width*0.55,
                child: TextCustom(text: text,color: PaletteColor.greyText,size: 16.0,)
              ),
              Spacer(),
              IconButton(
                onPressed: onTapEdit,
                icon: Icon(Icons.edit,color: PaletteColor.blueLight,size: 30),
              ),
              SizedBox(width: width*0.05),
              IconButton(
                onPressed: onTapDelete,
                icon: Icon(Icons.delete_forever,color: PaletteColor.red,size: 30,)
              ),
            ],
          ),
        )
      ],
    );
  }
}
