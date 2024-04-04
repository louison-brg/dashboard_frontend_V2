import 'package:flutter/material.dart';
import 'package:my_front/models/view_info.dart';
import '../models/creator_info.dart';
import '../services/youtube_api_service.dart';
import 'package:palette_generator/palette_generator.dart';
import '../widgets/creator_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/view_chart.dart';

class CreatorDashboard extends StatefulWidget {

  @override
  _CreatorDashboardState createState() => _CreatorDashboardState();
}

class _CreatorDashboardState extends State<CreatorDashboard> {
  final YoutubeApiService _apiService = YoutubeApiService();
  final TextEditingController _controller = TextEditingController();
  CreatorInfo? _creatorInfo;
  InfoChart? _infoChart;
  ColorScheme? colorScheme;

  // Here we define the _fetchCreatorInfo method
  void _fetchCreatorInfo(String youtuberName) async {
    if (youtuberName.isNotEmpty) {
      try {
        final info = await _apiService.fetchCreatorInfo(youtuberName);
        final colorScheme = await ColorScheme.fromImageProvider(
          provider: NetworkImage(info.channelProfilePicLink),
        );
        setState(() {
          _creatorInfo = info;
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
    final ColorScheme newcolorScheme = await ColorScheme.fromImageProvider(provider: NetworkImage(imageUrl),
      // ... Other properties
    );
    setState(() {
      colorScheme = newcolorScheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('YouTube Creator Dashboard',
            style: TextStyle(color: Colors.white)),
      ),
      body: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        backgroundColor: Theme.of(context).colorScheme.background,
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(16.0)
                    ),
                    if (_creatorInfo != null)
                      ViewersChart(
                        baseColor: Theme.of(context).colorScheme.onPrimary,
                        chartInfo: InfoChart(_creatorInfo!.channelName),
                          ),
                  ],
                )
            )
          ],
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
