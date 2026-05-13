import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:informa2/firebase_options.dart';
import 'package:informa2/modules/app/provider/auth_provider.dart';
import 'package:informa2/modules/app/screens/login_screen.dart';
import 'package:informa2/modules/news/provider/news_provider.dart';
import 'package:informa2/modules/radio/provider/program_provider.dart';
import 'package:informa2/modules/radio/provider/radio_provider.dart';
import 'package:informa2/modules/radio/service/audio_service.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true, 
  );
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviderApp()),
        ChangeNotifierProvider(create: (_) => RadioProvider()),
        ChangeNotifierProvider(create: (_) => MyAudioService()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => ProgramProvider()),
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
      home: const LoginScreen(),
    );
  }
}