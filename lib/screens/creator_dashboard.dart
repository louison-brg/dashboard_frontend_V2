import 'package:flutter/material.dart';
import '../models/creator_info.dart';
import '../models/post_info.dart';
import '../services/youtube_api_service.dart';
import 'package:palette_generator/palette_generator.dart';
import '../widgets/creator_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/post_card.dart';

class CreatorDashboard extends StatefulWidget {
  @override
  _CreatorDashboardState createState() => _CreatorDashboardState();
}

class _CreatorDashboardState extends State<CreatorDashboard> {
  final YoutubeApiService _apiService = YoutubeApiService();
  final TextEditingController _controller = TextEditingController();
  CreatorInfo? _creatorInfo;
  List<PostInfo> _latestPosts = [];
  PaletteGenerator? _paletteGenerator;

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
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
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
                            backgroundColor: (_paletteGenerator?.dominantColor?.color ??
                                Theme.of(context).cardColor)
                                .withOpacity(0.7),
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
            ],
          ),
        ),
      ),
    );
  }
}
