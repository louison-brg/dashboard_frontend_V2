import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package


class CreatorCard extends StatelessWidget {
  final String creatorName;
  final String subscribers;
  final String views;
  final String videos;
  final String description;
  final String youtubeLink;
  final String instagramLink;
  final String tiktokLink;
  final String twitterLink;
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
    required this.youtubeLink,
    required this.instagramLink,
    required this.tiktokLink,
    required this.twitterLink,

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
            color: backgroundColor.withOpacity(0.7), // Réduit l'opacité de la couleur de fond
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4.0,
                    color: backgroundColor.withOpacity(0.7),
                    child: Container(
                      width: 460,
                      height: 160,
                      margin: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 80.0,
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 150.0,
                                height: 150.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Ajoute un espace entre l'avatar et le texte
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      creatorName.length > 16 ? // Vérifier si le nom a plus de 16 caractères
                                      Text(
                                        creatorName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ) : // Si le nom a plus de 16 caractères
                                      Expanded( // Centrer le texte
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            creatorName,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0), // Hauteur constante au-dessus des icônes
                                  child: SocialMediaIcons(
                                    youtubeLink: youtubeLink,
                                    instagramLink: instagramLink,
                                    twitterLink: twitterLink,
                                    tiktokLink: tiktokLink,
                                  ),
                                ),
                                SizedBox(height: 2.0), // Espace supplémentaire entre les icônes et le bas de la carte
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

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: 510,
              height: 328,
              child: Card(
                elevation: 4.0,
                color: backgroundColor.withOpacity(0.7),
                // Réduit l'opacité de la couleur de fond
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //SizedBox(height: 5),
                      Card(
                        elevation: 2.0,
                        color: backgroundColor.withOpacity(0.7),
                        child: SizedBox(
                          width: 510,
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
                          width: 510,
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
                          width: 510,
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
                          width: 510,
                          height: 122,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              description,
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

class SocialMediaIcons extends StatelessWidget {
  final String? youtubeLink;
  final String? instagramLink;
  final String? tiktokLink;
  final String? twitterLink;

  SocialMediaIcons({
    this.youtubeLink,
    this.instagramLink,
    this.tiktokLink,
    this.twitterLink,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> socialButtons = [];
    socialButtons.add(SizedBox(width: 60));

    if (youtubeLink != "None") {
      socialButtons.add(_buildSocialImageButton('../../assets/youtube.png', youtubeLink!));
      socialButtons.add(SizedBox(width: 10));
    } else {
      socialButtons.add(_buildSocialImageButton('../../assets/youtube.png', youtubeLink));
      socialButtons.add(SizedBox(width: 10));
    }

    if (instagramLink != "None") {
      socialButtons.add(_buildSocialImageButton('../../assets/instagram.png', instagramLink!));
      socialButtons.add(SizedBox(width: 10));
    } else {
      socialButtons.add(_buildSocialImageButton('../../assets/instagram.png', instagramLink));
      socialButtons.add(SizedBox(width: 10));
    }

    if (twitterLink != "None") {
      socialButtons.add(_buildSocialImageButton('../../assets/twitter.png', twitterLink!));
      socialButtons.add(SizedBox(width: 10));
    } else {
      socialButtons.add(_buildSocialImageButton('../../assets/twitter.png', twitterLink));
      socialButtons.add(SizedBox(width: 10));
    }

    if (tiktokLink != "None") {
      socialButtons.add(_buildSocialImageButton('../../assets/tiktok.png', tiktokLink!));
      socialButtons.add(SizedBox(width: 10));
    } else {
      socialButtons.add(_buildSocialImageButton('../../assets/tiktok.png', tiktokLink));
      socialButtons.add(SizedBox(width: 10));
    }

    if (socialButtons.isNotEmpty) {
      socialButtons.removeLast();
    }

    return Row(
      children: socialButtons,
    );
  }

  Widget _buildSocialImageButton(String imagePath, String? link) {
    return link != "None"
        ? InkWell(
      onTap: () {
        _launchURL(link!); // Lance le lien fourni
      },
      child: Image.asset(
        imagePath,
        width: 30,
        height: 30,
      ),
    )
        : Image.asset(
      imagePath.replaceFirst('.png', '_black.png'), // Remplace l'icône par sa version noire
      width: 34,
      height: 34,
    ); // Retourne un conteneur vide si le lien est nul
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}