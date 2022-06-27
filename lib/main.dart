import '../utils/export.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  String login = FirebaseAuth.instance.currentUser!=null?'/home':'/login';
  print(login);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: HomeScreen(),
    initialRoute:login,
    onGenerateRoute: Routes.generateRoute,
  ));
}