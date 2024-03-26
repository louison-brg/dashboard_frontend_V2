import 'package:flutter/material.dart';

class CreatorCard extends StatelessWidget {
  final String creatorName;
  final String subscribers;
  final String views;
  final String videos;
  final String description;
  final String imageUrl;
  final Color backgroundColor;

  const CreatorCard({
    Key? key,
    required this.creatorName,
    required this.subscribers,
    required this.views,
    required this.videos,
    required this.description,
    required this.imageUrl,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4.0,
              color: backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 380,
                  height: 200,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 80.0,
                      ),
                      Expanded(
                        child: Text(
                          creatorName,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 404,
              height: 356,
              child: Card(
                elevation: 4.0,
                color: backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      _buildText("$subscribers Abonnés", textColor),
                      SizedBox(height: 20),
                      _buildText("$views Vues", textColor),
                      SizedBox(height: 20),
                      _buildText("$videos Vidéos", textColor),
                      SizedBox(height: 50),
                      Text(
                        description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}
