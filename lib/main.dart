import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:informa2/firebase_options.dart';
import 'package:informa2/modules/app/provider/auth_provider.dart';
import 'package:informa2/modules/app/screens/login_screen.dart';
import 'package:provider/provider.dart';

//Borrar
import 'package:informa2/modules/app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviderApp()),
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Informa2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}