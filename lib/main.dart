import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/day_provider.dart';
import 'services/veloquent_service.dart';
import 'theme/brutalist_theme.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/add_meal_page.dart';
import 'pages/exercise_detail_page.dart';
import 'pages/history_page.dart';
import 'pages/history_day_detail_page.dart';
import 'models/day.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VeloquentService.instance.init();
  runApp(const MonoLogApp());
}

class MonoLogApp extends StatelessWidget {
  const MonoLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DayProvider(),
      child: MaterialApp(
        title: 'MonoLog',
        debugShowCheckedModeBanner: false,
        theme: buildMonoLogTheme(),
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          Widget page;
          switch (settings.name) {
            case '/login':
              page = const LoginPage();
              break;
            case '/register':
              page = const RegisterPage();
              break;
            case '/home':
              page = const HomePage();
              break;
            case '/add-meal':
              page = const AddMealPage();
              break;
            case '/exercise-detail':
              page = const ExerciseDetailPage();
              break;
            case '/history':
              page = const HistoryPage();
              break;
            case '/history-detail':
              final day = settings.arguments as Day;
              page = HistoryDayDetailPage(day: day);
              break;
            default:
              page = const LoginPage();
          }

          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
    );
  }
}
