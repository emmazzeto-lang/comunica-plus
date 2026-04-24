import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Força o aplicativo a iniciar sempre deitado
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MeuAppComunica());
  });
}

class MeuAppComunica extends StatelessWidget {
  const MeuAppComunica({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comunica+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}