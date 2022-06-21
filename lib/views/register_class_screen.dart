import '../utils/export.dart';

class RegisterClassScreen extends StatefulWidget {
  const RegisterClassScreen({Key? key}) : super(key: key);

  @override
  State<RegisterClassScreen> createState() => _RegisterClassScreenState();
}

class _RegisterClassScreenState extends State<RegisterClassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PaletteColor.primaryColor,
        centerTitle: true,
        title: TextCustom(text: 'TURMA',size: 20,color: PaletteColor.white,),
      ),
    );
  }
}
