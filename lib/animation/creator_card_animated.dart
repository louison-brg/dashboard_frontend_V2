import 'package:flutter/material.dart';
import 'package:my_front/models/creator_info.dart'; // Assurez-vous d'importer CreatorInfo depuis le bon emplacement
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

import '../widgets/creator_card.dart';
import 'slide_in_animation.dart';

class CreatorCardAnimated extends StatelessWidget {
  final CreatorInfo creatorInfo;

  const CreatorCardAnimated({Key? key, required this.creatorInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideInAnimation(
      direction: SlideDirection.fromBottom,
      child: CreatorCard(
        creatorName: creatorInfo.channelName,
        subscribers: creatorInfo.subscriberCount,
        views: creatorInfo.viewCount,
        videos: creatorInfo.videoCount,
        description: creatorInfo.channelDescription,
        imageUrl: creatorInfo.channelProfilePicLink,
        youtubeLink: creatorInfo.youtubeLink,
        instagramLink: creatorInfo.instagramLink,
        tiktokLink: creatorInfo.tiktokLink,
        twitterLink: creatorInfo.twitterLink,
        backgroundColor: Theme.of(context).colorScheme.background,
      )
    );
  }
}
