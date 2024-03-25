import 'package:flutter/material.dart';
import '../models/creator_info.dart';
import '../models/post_info.dart';
import '../services/youtube_api_service.dart';
import 'package:palette_generator/palette_generator.dart';
import '../widgets/post_card.dart';

class CreatorDashboard extends StatefulWidget {
  @override
  _CreatorDashboardState createState() => _CreatorDashboardState();
}

class _CreatorDashboardState extends State<CreatorDashboard> {
  final YoutubeApiService _apiService = YoutubeApiService();
  final TextEditingController _controller = TextEditingController();
  CreatorInfo? _creatorInfo;
  PaletteGenerator? _paletteGenerator;
  List<PostInfo> _latestPosts = [];
  Color? backgroundColor; // A variable to hold the dynamic background color

  void _fetchCreatorInfo() async {
    if (_controller.text.isNotEmpty) {
      try {
        final info = await _apiService.fetchCreatorInfo(_controller.text);
        final posts = await _apiService.fetchLatestPosts(info.channelId);
        final paletteGenerator = await PaletteGenerator.fromImageProvider(
          NetworkImage(info.channelProfilePicLink),
        );
        setState(() {
          _creatorInfo = info;
          _latestPosts = posts;
          _paletteGenerator = paletteGenerator;
          // Set the background color with some opacity
          backgroundColor = paletteGenerator.dominantColor?.color.withOpacity(0.5);
        });
      } catch (e) {
        print(e);
        _showErrorDialog();
      }
    }
  }

  void _showErrorDialog() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
        title: Text('Dashboard Créateur'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _fetchCreatorInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter a YouTuber's name",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _fetchCreatorInfo,
                ),
              ),
              onSubmitted: (value) => _fetchCreatorInfo(),
            ),
            if (_creatorInfo != null) ...[
              CircleAvatar(
                backgroundImage: NetworkImage(_creatorInfo!.channelProfilePicLink),
                radius: 40,
              ),
              SizedBox(height: 16),
              Text(_creatorInfo!.channelName, style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(_creatorInfo!.channelDescription, style: Theme.of(context).textTheme.bodyText2),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              ..._latestPosts.map((post) => PostCard(postInfo: post)).toList(),
            ],
          ],
        ),
      ),
      // Set the background color of the entire Scaffold to the dynamic theme with opacity
      backgroundColor: backgroundColor?.withOpacity(0.5) ?? Theme.of(context).colorScheme.background,
    );
  }
}
