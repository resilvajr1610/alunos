import '../utils/export.dart';

class RegisterMainScreen extends StatefulWidget {
  const RegisterMainScreen({Key? key}) : super(key: key);

  @override
  State<RegisterMainScreen> createState() => _RegisterMainScreenState();
}

class _RegisterMainScreenState extends State<RegisterMainScreen> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PaletteColor.primaryColor,
        centerTitle: true,
        title: TextCustom(text: 'CADASTROS',size: 20,color: PaletteColor.white,),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardCustom(
              text: 'Cadastrar Escola',
              onPressed: ()=>Navigator.pushNamed(context, "/register-school"),
            ),
            SizedBox(height: 20),
            CardCustom(
              text: 'Cadastrar Turma/Alunos',
              onPressed: ()=>Navigator.pushNamed(context, "/register-class"),
            ),
          ],
        ),
      ),
    );
  }
}
