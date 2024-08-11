import 'package:appattendance/homescreen.dart';
import 'package:appattendance/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'
    show Firebase, FirebaseOptions;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const KeyboardVisibilityProvider(
        child: AuthCheck(),
      ),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUser();

  }

  void _getCurrentUser() async{
  sharedPreferences = await SharedPreferences.getInstance();
  try{
    if(sharedPreferences.getString("employeeId") != null){
      setState(() {
        User.employeeId = sharedPreferences.getString("employeeId")!;
        userAvailable = true;
      });
    }
  }catch(e){
      setState(() {
        userAvailable = false;
      });
  }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable? const HomeScreen(): const LoginScreen();
  }
}

