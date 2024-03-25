import 'package:flutter/material.dart';
import '../models/creator_info.dart';
import '../services/youtube_api_service.dart';
import 'package:palette_generator/palette_generator.dart';

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
  void _fetchCreatorInfo() async {
    final String query = _controller.text.trim();
    if (query.isNotEmpty) {
      try {
        final info = await _apiService.fetchCreatorInfo(query);
        PaletteGenerator? palette = await PaletteGenerator.fromImageProvider(
          NetworkImage(info.channelProfilePicLink),
          size:
              Size(110, 110), // La taille de la zone pour choisir les couleurs
          maximumColorCount: 20, // Le nombre maximal de couleurs à choisir
        );
        setState(() {
          _creatorInfo = info;
          _paletteGenerator = palette;
        });
      } catch (e) {
        // Affichez un message d'erreur si quelque chose se passe mal
        print('Error fetching creator info: $e');
      }
    }
  }

  void _updatePaletteGenerator(String imageUrl) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
      // ... Other properties
    );
    setState(() {
      _paletteGenerator = generator;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen size for responsive design
    var screenSize = MediaQuery.of(context).size;

    // Determine if we're on a wide screen or not
    bool isWideScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _paletteGenerator?.dominantColor?.color ??
            Theme.of(context).colorScheme.primary,
        title: Text('YouTube Creator Dashboard',
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: _fetchCreatorInfo,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter YouTuber Name',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _fetchCreatorInfo();
                        } // Appelé quand on clique sur l'icône de recherche
                        ),
                  ),
                  onSubmitted: (value) {
                    _fetchCreatorInfo(); // Appelé quand on appuie sur Entrée
                  },
                ),
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
                        SizedBox(height: 16),
                        Text(
                          _creatorInfo!.channelName,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _creatorInfo!.channelDescription,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 16),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatistic(
                                  'Subscribers', _creatorInfo!.subscriberCount),
                              VerticalDivider(),
                              _buildStatistic('Views', _creatorInfo!.viewCount),
                              VerticalDivider(),
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
          SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}