import 'package:flutter/material.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: "Involve",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        timePickerTheme: TimePickerThemeData(backgroundColor: Colors.white),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
