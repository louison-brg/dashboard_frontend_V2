import 'package:flutter/material.dart';
import 'package:my_front/widgets/search_bar.dart';
import 'package:palette_generator/palette_generator.dart';
import 'models/creator_info.dart'; // Make sure this path is correct
import 'services/youtube_api_service.dart'; // Make sure this path is correct
import 'screens/creator_dashboard.dart' as creator;

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
      home:
      creator.CreatorDashboard(),
    );
  }
}

class CreatorDashboard extends StatefulWidget {
  @override
  _CreatorDashboardState createState() => _CreatorDashboardState();
}

class _CreatorDashboardState extends State<CreatorDashboard> {
  final YoutubeApiService _apiService = YoutubeApiService();
  final TextEditingController _controller = TextEditingController();
  CreatorInfo? _creatorInfo;
  PaletteGenerator? _paletteGenerator;

  void _fetchCreatorInfo(String youtuberName) async {
    if (youtuberName.isNotEmpty) {
      try {
        final info = await _apiService.fetchCreatorInfo(youtuberName);
        final palette = await PaletteGenerator.fromImageProvider(
          NetworkImage(info.channelProfilePicLink),
        );
        setState(() {
          _creatorInfo = info;
          _paletteGenerator = palette;
        });
      } catch (e) {
        print(e); // Log the error
        // Show an error dialog
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
            SearchAnchors(
              onSearch: _fetchCreatorInfo,
            ),
            SizedBox(height: 20),
            if (_creatorInfo != null) ...[
              CircleAvatar(
                backgroundImage: NetworkImage(_creatorInfo!.channelProfilePicLink),
                radius: 64,
              ),
              SizedBox(height: 8),
              Text(
                _creatorInfo!.channelName,
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                _creatorInfo!.channelDescription,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 8),
              Text('Subscribers: ${_creatorInfo!.subscriberCount}'),
              Text('Views: ${_creatorInfo!.viewCount}'),
              Text('Videos: ${_creatorInfo!.videoCount}'),
            ],
          ],
        ),
      ),
    );
  }
}
