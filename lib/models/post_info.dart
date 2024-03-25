class PostInfo {
  final String postDate;
  final String postTitle;
  final String postPicture;
  final String postViews;
  final String postLikes;
  final String postComments;
  final String postDuration;

  PostInfo({
    required this.postDate,
    required this.postTitle,
    required this.postPicture,
    required this.postViews,
    required this.postLikes,
    required this.postComments,
    required this.postDuration,
  });

  factory PostInfo.fromJson(Map<String, dynamic> json) {
    return PostInfo(
      postDate: json['postDate'],
      postTitle: json['postTitle'],
      postPicture: json['postPicture'] as String,
      postViews: json['postViews'].toString(),
      postLikes: json['postLikes'].toString(),
      postComments: json['postComments'].toString(),
      postDuration: json['postDuration'],
    );
  }
}
