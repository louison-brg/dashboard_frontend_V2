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

  // Remarque: il n'est pas nécessaire d'utiliser 'factory' pour un constructeur de classe
  PostInfo.fromJson(Map<String, dynamic> json)
      : postDate = json['postDate'] ?? '',
        postTitle = json['postTitle'] ?? '',
        postPicture = json['postPicture'] ?? '',
        postViews = json['postViews']?.toString() ?? '0',
        postLikes = json['postLikes']?.toString() ?? '0',
        postComments = json['postComments']?.toString() ?? '0',
        postDuration = json['postDuration'] ?? '';
}
