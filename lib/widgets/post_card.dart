import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_info.dart';

class PostCard extends StatelessWidget {
  final PostInfo postInfo;

  const PostCard({Key? key, required this.postInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Use CachedNetworkImage
            CachedNetworkImage(
              imageUrl: postInfo.postPicture,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            SizedBox(height: 10),
            Text(
              postInfo.postTitle,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Vues: ${postInfo.postViews}'),
            Text('Likes: ${postInfo.postLikes}'),
            Text('Commentaires: ${postInfo.postComments}'),
            Text('Durée: ${postInfo.postDuration}'),
          ],
        ),
      ),
    );
  }
}
