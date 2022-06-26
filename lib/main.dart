import '../utils/export.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: HomeScreen(),
    initialRoute:'/login',
    onGenerateRoute: Routes.generateRoute,
  ));
}