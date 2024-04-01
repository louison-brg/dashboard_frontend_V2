class CreatorInfo {
  final String channelDateOfCreation;
  final String channelName;
  final String channelDescription;
  final String channelId;
  final String channelProfilePicLink;
  final String viewCount;
  final String subscriberCount;
  final String videoCount;


  CreatorInfo({
    required this.channelDateOfCreation,
    required this.channelName,
    required this.channelDescription,
    required this.channelId,
    required this.channelProfilePicLink,
    required this.viewCount,
    required this.subscriberCount,
    required this.videoCount,

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

    );
  }
}
