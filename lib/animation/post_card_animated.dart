import 'package:flutter/material.dart';
import 'package:my_front/models/post_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/post_card.dart';
import 'slide_in_animation.dart';

class PostCardAnimated extends StatelessWidget {
  final PostInfo postInfo;

  const PostCardAnimated({super.key, required this.postInfo});

  @override
  Widget build(BuildContext context) {
    return SlideInAnimation(
      direction: SlideDirection.fromTop,
      child: PostCard(
        postInfo: postInfo,
      ),
    );
  }
}
