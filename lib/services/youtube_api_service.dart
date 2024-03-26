import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/creator_info.dart';
import '../services/youtube_api_service.dart';

class YoutubeApiService {
  // Replace with your actual backend URL
  final String _baseUrl = 'http://127.0.0.1:5000';

  // Fetches creator information by channel name
  Future<CreatorInfo> fetchCreatorInfo(String channelName) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/getCreatorInfos?channelName=$channelName'));
    if (response.statusCode == 200) {
      return CreatorInfo.fromJson(json.decode(response.body));
    } else {
      // You can throw a more specific exception based on the status code or response body
      throw Exception('Failed to load creator info');
    }
  }

// Optionally, if you have other endpoints, you can add more methods here
// For example, to fetch the latest posts by channel ID
// Future<List<PostInfo>> fetchLatestPosts(String channelId) async { ... }
}
