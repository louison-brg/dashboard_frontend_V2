import 'package:flutter/material.dart';
import 'package:my_front/models/view_info.dart';
import '../main.dart';
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
  final colorSchemeSeed = ColorScheme.fromSeed(seedColor: Colors.blueAccent);
  CreatorInfo? _creatorInfo;
  InfoChart? _infoChart;
  List<PostInfo> _latestPosts = [];
  late ColorScheme  currentColorScheme;
  late bool isLoading;

  @override
  void initState(){
    super.initState();
    currentColorScheme = colorSchemeSeed;
    isLoading=false;
  }

  Future<void> _updateImage(String provider) async {
    final ColorScheme newColorScheme = await ColorScheme.fromImageProvider(provider: NetworkImage(_creatorInfo!.channelProfilePicLink));
    setState(() {
      currentColorScheme = newColorScheme;
    });
  }

  void _fetchCreatorAndLatestPosts(String channelName) async {
    try {
      isLoading = true;
      final channelInfo = await _apiService.fetchCreatorInfo(channelName);
      final channelId = channelInfo.channelId;
      final posts = await _apiService.fetchLatestPosts(channelId);

          setState(() {
            _creatorInfo = channelInfo;
            _latestPosts = posts;
            isLoading = false;

          });
      if (_creatorInfo != null) {
        _updateImage(_creatorInfo!.channelProfilePicLink);
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to fetch data. Please try again later.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
      final ColorScheme colorScheme = currentColorScheme;

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
        child: isLoading
          ? const LinearProgressIndicator()
          : Row(
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
                    creatorName: _creatorInfo!.channelName
                  ),
              ],
            )
        )
      ],
    ),
    ),
    );
  }
}


