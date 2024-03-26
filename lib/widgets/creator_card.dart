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
    final textColor =
    brightness == Brightness.dark ? Colors.white : Colors.black;

    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4.0,
            color: backgroundColor.withOpacity(0.7),
            // Réduit l'opacité de la couleur de fond
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4.0,
                    color: backgroundColor.withOpacity(0.7),
                    child: Container(
                      width: 450,
                      height: 200,
                      margin: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 70.0,
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 160.0,
                                height: 160.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              creatorName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
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
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              width: 490,
              height: 294,
              child: Card(
                elevation: 4.0,
                color: backgroundColor.withOpacity(0.7),
                // Réduit l'opacité de la couleur de fond
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Card(
                        elevation: 2.0,
                        color: backgroundColor.withOpacity(0.7),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildText(
                                "$subscribers Abonnés", textColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Card(
                        elevation: 2.0,
                        color: backgroundColor.withOpacity(0.7),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildText("$views Vues", textColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Card(
                        elevation: 2.0,
                        color: backgroundColor.withOpacity(0.7),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildText("$videos Vidéos", textColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Card(
                        elevation: 2.0,
                        color: backgroundColor.withOpacity(0.7),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Description: $description",
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 14, color: textColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text, Color textColor) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
