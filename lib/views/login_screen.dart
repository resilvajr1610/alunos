import '../utils/export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controllerEmail = TextEditingController(text: 'teste@gmail.com');
  final _controllerPassword = TextEditingController(text: 'euridice');
  bool visibiblePassword = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _error = "";
  var obscure = true;

  _signFirebase() async {
    if (_controllerEmail.text.isNotEmpty) {
      setState(() {
        _error = "";
      });

      try {
        await _auth
            .signInWithEmailAndPassword(
                email: _controllerEmail.text.trim(),
                password: _controllerPassword.text.trim())
            .then((auth) async {
          Navigator.pushReplacementNamed(context, "/home");
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "unknown") {
          setState(() {
            _error = "A senha está vazia!";
            showSnackBar(context, _error, _scaffoldKey);
          });
        } else if (e.code == "invalid-email") {
          setState(() {
            _error = "Digite um e-mail válido!";
            showSnackBar(context, _error, _scaffoldKey);
          });
        } else {
          setState(() {
            _error = e.code;
            showSnackBar(context, _error, _scaffoldKey);
          });
        }
      }
    } else {
      setState(() {
        _error = "Preencha seu email";
        showSnackBar(context, _error, _scaffoldKey);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: PaletteColor.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.03),
                SizedBox(
                  height: height * 0.25,
                  width: height * 0.3,
                  child: Image.asset("assets/image/logo.png"),
                ),
                TextCustom(
                    text: 'Registro de presença de alunos',
                    size: 20.0,
                    fontWeight: FontWeight.bold,
                ),
                SizedBox(height: height * 0.02),
                SizedBox(height: height * 0.06),
                Container(
                  width: width * 0.6,
                  child: TextCustom(
                      text: 'E - mail',
                  ),
                ),
                Input(
                  controller: _controllerEmail,
                  hint: 'E - mail',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: height * 0.02),
                Container(
                  width: width * 0.6,
                  child: TextCustom(
                      text: 'Senha',
                      color: PaletteColor.primaryColor,
                      size: 14.0,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start
                  ),
                ),
                Input(
                  obscure: obscure,
                  sizeIcon: 20.0,
                  controller: _controllerPassword,
                  hint: 'Senha',
                  keyboardType: TextInputType.visiblePassword,
                  colorIcon: PaletteColor.primaryColor,
                  onTap: (){
                    setState(() {
                      obscure?obscure=false:obscure=true;
                    });
                  }
                ),
                SizedBox(height: height * 0.03),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonCustom(
                    onPressed: () => _signFirebase(),
                    text: "Entrar",
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
