import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_grocery_admin/core/view_models/auth_view_model/auth_view_model_provider.dart';
import 'package:green_grocery_admin/ui/login_page.dart';
import 'ui/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.read(authViewModelProvider).user;
    final Color accentColor = Color(0xFF4E598C);
    return MaterialApp(
      title: 'Green Grocery Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFEF6EC),
        primaryColor: Color(0xFFFCAF58),
        primaryColorDark: Color(0xFFFF8C42),
        backgroundColor: Colors.white,
        accentColor: accentColor,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: accentColor,
            shape: RoundedRectangleBorder(),
          ),
        ),
        primaryColorLight: Color(0xFFFDEDD8),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: accentColor),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          buttonColor: accentColor,
          textTheme: ButtonTextTheme.primary,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: user != null ? HomePage() : LoginPage(),
    );
  }
}
