import '../utils/export.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: ListPresenceScreen(),
    initialRoute:'/login',
    onGenerateRoute: Routes.generateRoute,
  ));
}