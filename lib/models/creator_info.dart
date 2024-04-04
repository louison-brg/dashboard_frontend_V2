class CreatorInfo {
  final String channelDateOfCreation;
  final String channelName;
  final String channelDescription;
  final String channelId;
  final String channelProfilePicLink;
  final String viewCount;
  final String subscriberCount;
  final String videoCount;
  final String youtubeLink; // Lien YouTube
  final String instagramLink; // Lien Instagram
  final String facebookLink; // Lien Facebook
  final String tiktokLink; // Lien TikTok
  final String twitterLink; // Lien Twitter


  CreatorInfo({
    required this.channelDateOfCreation,
    required this.channelName,
    required this.channelDescription,
    required this.channelId,
    required this.channelProfilePicLink,
    required this.viewCount,
    required this.subscriberCount,
    required this.videoCount,
    required this.youtubeLink, // Ajout des liens sociaux
    required this.instagramLink,
    required this.facebookLink,
    required this.tiktokLink,
    required this.twitterLink,
  });

  factory CreatorInfo.fromJson(Map<String, dynamic> json) {
    return CreatorInfo(
      channelDateOfCreation: json['channelDateOfCreation'] ?? '',
      channelName: json['channelName'] ?? '',
      channelDescription: json['channelDescription'] ?? '',
      channelId: json['channelId'] ?? '',
      channelProfilePicLink: json['channelProfilePicLink'] ?? '',
      viewCount: json['viewCount']?.toString() ?? '0',
      subscriberCount: json['subscriberCount']?.toString() ?? '0',
      videoCount: json['videoCount']?.toString() ?? '0',
      youtubeLink: json['youtube'] ?? '', // Récupération des liens sociaux
      instagramLink: json['instagram'] ?? '',
      facebookLink: json['facebook'] ?? '',
      tiktokLink: json['tiktok'] ?? '',
      twitterLink: json['twitter'] ?? '',
    );
  }
}