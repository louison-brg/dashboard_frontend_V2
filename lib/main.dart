import 'package:flutter/material.dart';
import 'package:my_front/widgets/search_bar.dart';
import 'package:palette_generator/palette_generator.dart';
import 'models/creator_info.dart'; // Make sure this path is correct
import 'services/youtube_api_service.dart'; // Make sure this path is correct
import 'screens/creator_dashboard.dart';

void main() async {
  runApp(App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  void handleImageSelect(String imageUrl) {
    final String url = ColorImageProvider.values[value].url;
    ColorScheme.fromImageProvider(provider: NetworkImage(url))
        .then((newScheme) {
      setState(() {
        imageColorScheme = newScheme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Creator Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        // Define the base theme with Material 3 features
        colorSchemeSeed:
          Colors.blue,
        colorScheme:
          ? imageColorScheme.color
          : null,
      ),
      home:
      CreatorDashboard(),
    );
  }
}
