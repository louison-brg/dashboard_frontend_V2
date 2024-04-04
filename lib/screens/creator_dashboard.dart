import 'package:flutter/material.dart';
import 'package:my_front/models/view_info.dart';
import '../models/creator_info.dart';
import '../models/post_info.dart';
import '../services/youtube_api_service.dart';
import 'package:palette_generator/palette_generator.dart';
import '../widgets/creator_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/view_chart.dart';
import '../widgets/post_card.dart';

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
  List<PostInfo> _latestPosts = [];

  void _fetchCreatorAndLatestPosts(String channelName) async {
    try {
      final channelInfo = await _apiService.fetchCreatorInfo(channelName);
      final channelId = channelInfo.channelId;
      final posts = await _apiService.fetchLatestPosts(channelId);

      setState(() {
        _creatorInfo = channelInfo;
        _latestPosts = posts;
      });
    } catch (e) {
      print(e);
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
        title: const Text(
          'YouTube Creator Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFields(onSearch: _fetchCreatorAndLatestPosts),
                    if (_creatorInfo != null)
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,bottom: 8.0,right: 30.0),
                        child: CreatorCard(
                          creatorName: _creatorInfo!.channelName,
                          subscribers: _creatorInfo!.subscriberCount,
                          views: _creatorInfo!.viewCount,
                          videos: _creatorInfo!.videoCount,
                          description: _creatorInfo!.channelDescription,
                          imageUrl: _creatorInfo!.channelProfilePicLink,
                          youtubeLink: _creatorInfo!.youtubeLink,
                          instagramLink: _creatorInfo!.instagramLink,
                          tiktokLink: _creatorInfo!.tiktokLink,
                          twitterLink: _creatorInfo!.twitterLink,
                          backgroundColor: Theme.of(context).colorScheme.background,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _latestPosts.length,
                  itemBuilder: (context, index) {
                    return PostCard(postInfo: _latestPosts[index]);
                  },
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
            ],
          ),
        ),
      ),
    );
  }
}