import 'package:flutter/material.dart';
import 'package:my_front/widgets/search_bar.dart';
import 'package:palette_generator/palette_generator.dart';
import 'screens/creator_dashboard.dart';
import 'models/creator_info.dart';
import 'services/youtube_api_service.dart';
import 'widgets/creator_card.dart';


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
      home: MyHomePage(), // Utilisez MyHomePage comme page d'accueil
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final YoutubeApiService _apiService = YoutubeApiService();
  final TextEditingController _controller = TextEditingController();
  CreatorInfo? _creatorInfo;
  PaletteGenerator? _paletteGenerator;

  void _fetchCreatorInfo() async {
    if (_controller.text.isNotEmpty) {
      try {
        final info = await _apiService.fetchCreatorInfo(_controller.text);
        final palette = await PaletteGenerator.fromImageProvider(
          NetworkImage(info.channelProfilePicLink),
        );
        setState(() {
          _creatorInfo = info;
          _paletteGenerator = palette;
        });
      } catch (e) {
        print(e); // Log the error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch data. Please try again later.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Creator Dashboard'),
        backgroundColor: _paletteGenerator?.dominantColor?.color ?? Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter YouTuber Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _fetchCreatorInfo,
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _fetchCreatorInfo(),
            ),
            SizedBox(height: 20),
            if (_creatorInfo != null) // Vérifiez que _creatorInfo n'est pas nul
              CreatorCard(
                creatorName: _creatorInfo!.channelName,
                subscribers: _creatorInfo!.subscriberCount,
                views: _creatorInfo!.viewCount,
                videos: _creatorInfo!.videoCount,
                description: _creatorInfo!.channelDescription,
                imageUrl: _creatorInfo!.channelProfilePicLink,
                backgroundColor: (_paletteGenerator?.dominantColor?.color ?? Theme.of(context).cardColor).withOpacity(0.7),
              ),
          ],
        ),
      ),
    );
  }
}
