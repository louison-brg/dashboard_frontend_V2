import 'package:flutter/material.dart';
import 'package:my_front/models/view_info.dart';
import '../animation/creator_card_animated.dart';
import '../animation/post_card_animated.dart';
import '../main.dart';
import '../models/creator_info.dart';
import '../models/post_info.dart';
import '../services/youtube_api_service.dart';
import 'package:palette_generator/palette_generator.dart';
import '../widgets/creator_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/view_chart.dart';
import '../widgets/post_card.dart';
import 'package:lottie/lottie.dart';

class CreatorDashboard extends StatefulWidget {
  const CreatorDashboard({super.key});

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
  late ColorScheme currentColorScheme;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    currentColorScheme = colorSchemeSeed;
    isLoading = false;
  }

  Future<void> _updateImage(String provider) async {
    final ColorScheme newColorScheme =
    await ColorScheme.fromImageProvider(
        provider: NetworkImage(_creatorInfo!.channelProfilePicLink));
    setState(() {
      currentColorScheme = newColorScheme;
    });
  }

  void _fetchCreatorAndLatestPosts(String channelName) async {
    try {

      // Mettre isLoading à true avant de démarrer la recherche
      setState(() {
        isLoading = true;
      });
      final channelInfo = await _apiService.fetchCreatorInfo(channelName);
      final channelId = channelInfo.channelId;
      final posts = await _apiService.fetchLatestPosts(channelId);

      // Mettre à jour les données et isLoading seulement après le chargement des nouvelles données
      setState(() {
        _creatorInfo = channelInfo;
        _latestPosts = posts;
      });


      if (_creatorInfo != null) {
        _updateImage(_creatorInfo!.channelProfilePicLink);
      }

      // Mettre isLoading à false lorsque la recherche est terminée
      setState(() {
        isLoading = false;
      });
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

      // Mettre isLoading à false en cas d'échec de la recherche
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = currentColorScheme;

    return Scaffold(
      body:isLoading
          ? Center(
        // Center the loading animation in the available space
        child: Lottie.asset(
          'loading.json', // Path to your Lottie file
          width: 200, // Specify the size of the animation
          height: 200,
          fit: BoxFit.fill, // Make the animation fill the given size
        ),
      )
      :Align(
        alignment: Alignment.topLeft,
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
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
                      child: isLoading
                          ? SizedBox.shrink() // Remplacer le widget par un SizedBox lorsque isLoading est true
                          : _creatorInfo != null
                          ? CreatorCardAnimated(creatorInfo: _creatorInfo!)
                          : SizedBox.shrink(), // Utilisez SizedBox.shrink() pour ne pas afficher le widget si _creatorInfo est null

                    ),

                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 10, right: 10),
                child: ListView.builder(
                  itemCount: _latestPosts.length,
                  itemBuilder: (context, index) {
                    final bool isLastItem = index == _latestPosts.length - 1;
                    // Ajoute un Padding de 20 pixels entre chaque élément, sauf pour le dernier
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == 4 ? 0 : 22,
                      ),
                      child: isLoading
                          ? SizedBox.shrink()
                          : _latestPosts[index] != null
                          ? PostCardAnimated(postInfo: _latestPosts[index])
                          : SizedBox.shrink(), // Utilisez SizedBox.shrink() pour ne pas afficher le widget si _latestPosts[index] est null
                    );
                  },
                ),
              ),

            ),
            
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_creatorInfo != null)
                  ViewersChart1(
                    baseColor: Theme.of(context).colorScheme.onPrimary,
                    creatorName: _creatorInfo!.channelName,
                  ),
                if (_creatorInfo != null)
                  ViewersChart2(
                    baseColor: Theme.of(context).colorScheme.onPrimary,
                    creatorName: _creatorInfo!.channelName,
                  ),
                if (_creatorInfo != null)
                  ViewersChart3(
                    baseColor: Theme.of(context).colorScheme.onPrimary,
                    creatorName: _creatorInfo!.channelName,
                  ),
              ],
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }
}
