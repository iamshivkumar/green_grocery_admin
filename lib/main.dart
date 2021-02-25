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
    ///Celadon Green
    final Color accentColor = Color(0xFF3e8b83);
    return MaterialApp(
      title: 'Green Grocery Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF3F9F3),
        ///Forest Green Crayola
        primaryColor: Color(0xFF74a57f),
        ///Polished Pine
        primaryColorDark: Color(0xFF599881),
        backgroundColor: Colors.white,
        accentColor: accentColor,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: accentColor,
            shape: RoundedRectangleBorder(),
          ),
        ),
        ///Honeydue
        primaryColorLight: Color(0xFFE7F3E6),
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
