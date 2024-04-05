import 'package:flutter/material.dart';
import '../models/post_info.dart';

class PostCard extends StatefulWidget {
  final PostInfo postInfo;

  const PostCard({Key? key, required this.postInfo}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  double _elevation = 4.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _elevation = 20.0),
      onExit: (_) => setState(() => _elevation = 4.0),
      child: AnimatedPhysicalModel(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        elevation: _elevation,
        shape: BoxShape.rectangle,
        shadowColor: Colors.black,
        color: Colors.grey[200]!,
        borderRadius: BorderRadius.circular(12), // Ajout des coins arrondis
        child: SizedBox(
          height: 205,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                widget.postInfo.postPicture,
                fit: BoxFit.cover,
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postInfo.postTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Spacer(), // Pour pousser les icônes en haut
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.remove_red_eye),
                              const SizedBox(width: 4),
                              Text(widget.postInfo.postViews),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.thumb_up),
                              const SizedBox(width: 4),
                              Text(widget.postInfo.postLikes),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.comment),
                              const SizedBox(width: 4),
                              Text(widget.postInfo.postComments),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20), // Espacement entre les icônes et la date
                      Text(
                        widget.postInfo.postDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
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
