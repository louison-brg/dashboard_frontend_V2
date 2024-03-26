import 'package:flutter/material.dart';
import '../models/creator_info.dart';
import '../services/youtube_api_service.dart';
import 'package:palette_generator/palette_generator.dart';
import '../widgets/creator_card.dart';
import '../widgets/search_bar.dart';

class CreatorDashboard extends StatefulWidget {

  @override
  _CreatorDashboardState createState() => _CreatorDashboardState();
}

class _CreatorDashboardState extends State<CreatorDashboard> {
  final YoutubeApiService _apiService = YoutubeApiService();
  final TextEditingController _controller = TextEditingController();
  CreatorInfo? _creatorInfo;
  PaletteGenerator? _paletteGenerator;

  // Here we define the _fetchCreatorInfo method
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

  void _updatePaletteGenerator(String imageUrl) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl),
      // ... Other properties
    );
    setState(() {
      _paletteGenerator = generator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _paletteGenerator?.dominantColor?.color ??
            Theme.of(context).colorScheme.primary,
        title: const Text('YouTube Creator Dashboard',
            style: TextStyle(color: Colors.white)),
      ),
      body: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFields(onSearch: _fetchCreatorInfo),
              ),
              if (_creatorInfo != null)
                CreatorCard(
                  creatorName: _creatorInfo!.channelName,
                  subscribers: _creatorInfo!.subscriberCount,
                  views: _creatorInfo!.viewCount,
                  videos: _creatorInfo!.videoCount,
                  description: _creatorInfo!.channelDescription,
                  imageUrl: _creatorInfo!.channelProfilePicLink,
                  backgroundColor: (_paletteGenerator?.dominantColor?.color ??
                          Theme.of(context).cardColor)
                      .withOpacity(0.7),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
