import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'screens/creator_dashboard.dart' as Creator; // Make sure this path is correct
import 'models/creator_info.dart'; // Make sure this path is correct
import 'services/youtube_api_service.dart'; // Make sure this path is correct

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
      home: Creator.CreatorDashboard(),
    );
  }
}

class MyNetworkImage extends StatefulWidget {
  @override
  _MyNetworkImageState createState() => _MyNetworkImageState();
}

class _MyNetworkImageState extends State<MyNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://yt3.ggpht.com/ytc/AIdro_nJXKFW82upNmPtUK-oykmjF-UDNvW6vuj-AVODmw=s88-c-k-c0xffffffff-no-rj-mo',
      scale: 1.0,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Cette fonction est appelée lorsqu'une erreur de chargement se produit
        return Icon(Icons.error); // Icône d'erreur affichée en cas d'échec de chargement de l'image
      },
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
              SizedBox(height: 8),
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
