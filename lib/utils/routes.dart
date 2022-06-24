import '../utils/export.dart';

class Routes{
    static Route<dynamic>? generateRoute(RouteSettings settings){
      final args = settings.arguments;

      switch(settings.name){
        case "/login" :
          return MaterialPageRoute(
              builder: (_) => LoginScreen()
          );
        case "/home" :
          return MaterialPageRoute(
              builder: (_) => HomeScreen()
          );
        case "/register-main" :
          return MaterialPageRoute(
              builder: (_) => RegisterMainScreen()
          );
        case "/register-school" :
          return MaterialPageRoute(
              builder: (_) => RegisterSchoolScreen()
          );
        case "/register-student" :
          return MaterialPageRoute(
              builder: (_) => RegisterStudentScreen(idClass: args as String)
          );
        case "/register-class" :
          return MaterialPageRoute(
              builder: (_) => RegisterClassScreen()
          );
        case "/register-presence" :
          return MaterialPageRoute(
              builder: (_) => RegisterPresenceScreen(idClass: args as String)
          );
        case "/list-class" :
          return MaterialPageRoute(
              builder: (_) => ListClassScreen()
          );
        case "/list-presence" :
          return MaterialPageRoute(
              builder: (_) => ListPresenceScreen()
          );
      }
    }
  }