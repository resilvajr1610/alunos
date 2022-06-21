import '../utils/export.dart';

class RegisterSchoolScreen extends StatefulWidget {
  const RegisterSchoolScreen({Key? key}) : super(key: key);

  @override
  State<RegisterSchoolScreen> createState() => _RegisterSchoolScreenState();
}

class _RegisterSchoolScreenState extends State<RegisterSchoolScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PaletteColor.primaryColor,
        centerTitle: true,
        title: TextCustom(text: 'ESCOLA',size: 20,color: PaletteColor.white,),
      ),
    );
  }
}
