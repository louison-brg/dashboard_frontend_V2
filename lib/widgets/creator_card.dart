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
  final String facebookLink;
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
    required this.facebookLink,
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
                      width: 450,
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
                                width: 160.0,
                                height: 160.0,
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
                                    facebookLink: facebookLink,
                                    tiktokLink: tiktokLink,
                                    twitterLink: twitterLink,
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
                      //SizedBox(height: 5),
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
  final String? facebookLink;
  final String? tiktokLink;
  final String? twitterLink;

  SocialMediaIcons({
    this.youtubeLink,
    this.instagramLink,
    this.facebookLink,
    this.tiktokLink,
    this.twitterLink,
  });

  @override
  Widget build(BuildContext context) {
    // Créer une liste pour stocker les boutons et les SizedBox
    List<Widget> socialButtons = [];
    socialButtons.add(SizedBox(width: 10));

    // Ajouter le bouton Instagram et SizedBox d'espacement si le lien est présent
    if (instagramLink != "None") {
      socialButtons.add(_buildSocialImageButton('../../assets/instagram.png', instagramLink));
      socialButtons.add(SizedBox(width: 10));
    }

    // Ajouter le bouton Facebook et SizedBox d'espacement si le lien est présent
    if (facebookLink != "None") {
      socialButtons.add(_buildSocialImageButton('../../assets/facebook.png', facebookLink));
      socialButtons.add(SizedBox(width: 10));
    }

    // Ajouter le bouton TikTok et SizedBox d'espacement si le lien est présent
    if (tiktokLink != "None") {
      socialButtons.add(_buildSocialImageButton('../../assets/tiktok.png', tiktokLink));
      socialButtons.add(SizedBox(width: 10));
    }

    // Ajouter le bouton Twitter et SizedBox d'espacement si le lien est présent
    if (twitterLink != "None") {
      socialButtons.add(_buildSocialImageButton('../../assets/twitter.png', twitterLink));
      socialButtons.add(SizedBox(width: 10));
    }

    // Retirer le dernier SizedBox car il n'est pas nécessaire après le dernier bouton
    if (socialButtons.isNotEmpty) {
      socialButtons.removeLast();
    }

    // Retourner la rangée contenant les boutons sociaux
    return Row(
      children: socialButtons,
    );
  }



  Widget _buildSocialImageButton(String imagePath, String? link) {
    return link != "None"
        ? InkWell(
      onTap: () {
        _launchURL(link!); // Launch the provided link
      },
      child: Image.asset(
        imagePath,
        width: 30,
        height: 30,
      ),
    )
        : const SizedBox(); // Return an empty container if the link is null
  }

  // Function to launch the provided URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
