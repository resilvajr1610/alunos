import '../utils/export.dart';

class ShowDialogCustom extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final List<Widget> list;
  final listContent;

  ShowDialogCustom({
    required this.controller,
    required this.title,
    required this.list,
    required this.hint,
    required this.listContent
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Container(
        alignment: Alignment.center,
        height: 50,
        width: 300,
        child: TextCustom(text: title,color: PaletteColor.greyText,fontWeight: FontWeight.bold,)),
      titleTextStyle: TextStyle(color: PaletteColor.greyLight, fontSize: 20),
      actionsAlignment: MainAxisAlignment.center,
      content: listContent,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: this.list,
    );
  }
}
