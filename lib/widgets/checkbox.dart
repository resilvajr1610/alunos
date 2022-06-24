import '../utils/export.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({ required this.item });

  final CheckBoxModel item;

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      side: BorderSide(color: PaletteColor.primaryColor,width: 2),
      activeColor: PaletteColor.primaryColor,
      title: TextCustom(text:widget.item.number+' - '+ widget.item.texto,color: PaletteColor.greyText,),
      value: widget.item.checked,
      onChanged: (value){
        setState((){
          widget.item.checked = value!;
        });
      },
    );
  }
}