import 'package:flutter/material.dart';
import '../models/post_info.dart';

class PostCard extends StatelessWidget {
  final PostInfo postInfo;

  const PostCard({Key? key, required this.postInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Card(
        elevation: 4.0,
        color: Colors.grey[200],
        child: SizedBox(
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                postInfo.postPicture,
                fit: BoxFit.cover,
                width: 250.0,
                height: 160.0,
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postInfo.postTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        postInfo.postDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye),
                          const SizedBox(width: 4),
                          Text(postInfo.postViews),
                          const SizedBox(width: 16),
                          const Icon(Icons.thumb_up),
                          const SizedBox(width: 4),
                          Text(postInfo.postLikes),
                          const SizedBox(width: 16),
                          const Icon(Icons.comment),
                          const SizedBox(width: 4),
                          Text(postInfo.postComments),
                        ],
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
}