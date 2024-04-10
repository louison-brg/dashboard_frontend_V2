import 'dart:convert';
import 'package:flutter/services.dart';

class InfoChart {
  late String creatorName;
  late List<String> titles = [];
  late List<String> dates = [];
  late List<int> views = [];
  late List<int> likes = [];
  late List<int> comments = [];

  InfoChart(this.creatorName);

  Future<void> loadJsonData(String creatorName) async {
    String creatorData = await rootBundle.loadString('/creator_infos.json');
    List<dynamic> creatorList = json.decode(creatorData);

    String? creatorId;
    for (var creator in creatorList) {
      if (creator['channelName'] == creatorName) {
        creatorId = creator['channelId'];
        break;
      }
    }
    if (creatorId == null) {
      throw Exception("Creator not found");
    }

    String postsData = await rootBundle.loadString('/latest_postsV2.json');
    List<dynamic> postsList = json.decode(postsData);

    // Utilisation d'un ensemble pour stocker les dates uniques
    Set<String> uniqueDates = {};

    List<Map<String, dynamic>> creatorPosts = [];
    for (var post in postsList) {
      if (post['channelId'] == creatorId) {
        creatorPosts.add(post);
        // Ajout de la date à l'ensemble des dates uniques
        uniqueDates.add(post['postDate']);
      }
    }

    // Conversion de l'ensemble des dates uniques en liste ordonnée
    dates = uniqueDates.toList()..sort((a, b) => a.compareTo(b));

    // Inversion de l'ordre des dates
    dates = dates.reversed.toList();

    titles = creatorPosts.map((post) =>  post['postTitle'] as String).toList();
    views = creatorPosts.map<int>((post) => int.parse(post['postViews'])).toList();
    likes = creatorPosts.map<int>((post) => int.parse(post['postLikes'])).toList();
    comments = creatorPosts.map<int>((post) => int.parse(post['postComments'])).toList();
  }

  String getCreatorName(){
    return creatorName;
  }

  List<String> getTitles() {
    return titles;
  }
  List<String> getDates() {
    return dates;
  }
  List<int> getLikes() {
    return likes;
  }

  List<int> getViews() {
    return views;
  }

  List<int> getComments() {
    return comments;
  }
}
