import 'package:flutter/material.dart';
import 'package:fyp_animalcare_app/pages/lost_found_screens/lost_and_found.dart';
import 'package:fyp_animalcare_app/pages/pet_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Import this to use the generated Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LostAndFoundScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}



