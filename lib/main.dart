import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:RHOLIC/Admin_interfaces/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.bottom],
  );

  runApp(const ReadaholicApp());
}

class ReadaholicApp extends StatelessWidget {
  const ReadaholicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Readaholic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Ne force pas une police globale ici :
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Ne pas ajouter fontFamily ou textTheme ici si tu veux varier les polices
      ),
      home: SplashScreen(),
    );
  }
}
