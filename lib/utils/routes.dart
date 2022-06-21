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
              builder: (_) => RegisterStudentScreen()
          );
        case "/register-class" :
          return MaterialPageRoute(
              builder: (_) => RegisterClassScreen()
          );
      }
    }
  }