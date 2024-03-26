import 'package:flutter/material.dart';
import '../models/creator_info.dart';
import '../services/youtube_api_service.dart';
import 'package:palette_generator/palette_generator.dart';
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
        alignment:Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFields(onSearch: _fetchCreatorInfo,)
              ),
              if (_creatorInfo != null)
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(_creatorInfo!.channelProfilePicLink),
                          radius: 40,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          _creatorInfo!.channelName,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _creatorInfo!.channelDescription,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatistic(
                                  'Subscribers', _creatorInfo!.subscriberCount),
                              const VerticalDivider(),
                              _buildStatistic('Views', _creatorInfo!.viewCount),
                              const VerticalDivider(),
                              _buildStatistic(
                                  'Videos', _creatorInfo!.videoCount),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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