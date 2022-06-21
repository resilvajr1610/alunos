import '../utils/export.dart';

class RegisterStudentScreen extends StatefulWidget {
  const RegisterStudentScreen({Key? key}) : super(key: key);

  @override
  State<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PaletteColor.primaryColor,
        centerTitle: true,
        title: TextCustom(text: 'ALUNOS',size: 20,color: PaletteColor.white,),
      ),
    );
  }
}
