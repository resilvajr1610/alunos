import '../utils/export.dart';

class ShowDialogCustom extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final List<Widget> list;

  ShowDialogCustom({
    required this.controller,
    required this.title,
    required this.list,
    required this.hint,
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
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 30,
              width: 300,
              child: TextCustom(text: 'Escola')
            ),
            Input(
                obscure: false,
                keyboardType: TextInputType.text,
                controller: this.controller,
                hint: this.hint,
                fonts: 20
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: this.list,
    );
  }
}
