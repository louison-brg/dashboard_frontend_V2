import 'package:flutter/material.dart';
import '../models/post_info.dart';

class PostCard extends StatelessWidget {
  final PostInfo postInfo;

  const PostCard({Key? key, required this.postInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debug print the image URL
    debugPrint('Post image URL: ${postInfo.postPicture}');

    return Card(
      elevation: 4.0, // Added elevation for a subtle shadow
      margin: EdgeInsets.all(8.0), // Margin around the card
      child: Padding(
        padding: EdgeInsets.all(8.0), // Padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Set a fixed size for the image using a Container
            Container(
              width: double.infinity, // Container takes the full width of the card
              height: 200, // Fixed height for the image
              child: Image.network(
                postInfo.postPicture,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Log the error to the console
                  debugPrint('Failed to load image: $error');
                  // Display an error icon if the image fails to load
                  return Center(child: Icon(Icons.error, size: 48));
                },
              ),
            ),
            SizedBox(height: 10), // Spacing between image and title
            Text(
              postInfo.postTitle,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5), // Spacing between title and views
            Text('Vues: ${postInfo.postViews}'),
            Text('Likes: ${postInfo.postLikes}'),
            Text('Commentaires: ${postInfo.postComments}'),
            Text('Durée: ${postInfo.postDuration}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
