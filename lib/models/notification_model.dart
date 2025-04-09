class NotificationModel {
  final String profileImage;
  final String starImage;
  final String username;
  final String content;
  final String? link;

  NotificationModel({
    required this.profileImage,
    required this.starImage,
    required this.username,
    required this.content,
    this.link,
  });
}

class MentionModel {
  final String name;
  final String username;
  final String date;
  final String profileImage;
  final String mentionText;
  final String taggedUsers;
  final String articleText;
  final String link;
  final String mentionImage;
  final int comments;
  final int retweets;
  final int likes;

  MentionModel({
    required this.name,
    required this.username,
    required this.date,
    required this.profileImage,
    required this.mentionText,
    required this.taggedUsers,
    required this.articleText,
    required this.link,
    required this.mentionImage,
    required this.comments,
    required this.retweets,
    required this.likes,
  });
}
