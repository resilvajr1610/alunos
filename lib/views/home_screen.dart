import '../utils/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PaletteColor.primaryColor,
        centerTitle: true,
        title: TextCustom(text: 'HOME',size: 20,color: PaletteColor.white,),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardCustom(
              text: 'Cadastros',
              onPressed: ()=>Navigator.pushNamed(context, "/register-main"),
            ),
            SizedBox(height: 20),
            CardCustom(
              textColor: PaletteColor.white,
              text: 'Registrar presença',
              background: PaletteColor.primaryColor,
              onPressed: (){

              },
            ),
          ],
        ),
      ),
    );
  }
}
