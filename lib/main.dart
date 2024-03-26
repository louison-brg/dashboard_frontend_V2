import 'package:flutter/material.dart';
import 'package:my_front/widgets/search_bar.dart';
import 'package:palette_generator/palette_generator.dart';

import 'models/creator_info.dart'; // Make sure this path is correct
import 'services/youtube_api_service.dart'; // Make sure this path is correct
import 'screens/creator_dashboard.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Creator Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        // Define the base theme with Material 3 features
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),

