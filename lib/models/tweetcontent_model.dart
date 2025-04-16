class TweetContent {
  final String content;
  final String? image;
  
  TweetContent({
    required this.content,
    this.image,
  });
  
  bool get isEmpty => content.isEmpty && (image == null || image!.isEmpty);
  bool get isNotEmpty => !isEmpty;
}