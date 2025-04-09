import 'package:flutter/material.dart';
import 'package:twitter_task/models/notification_model.dart';

class MentionList extends StatelessWidget {
  final List<MentionModel> mentions;

  const MentionList({super.key, required this.mentions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mentions.length,
      itemBuilder: (context, index) {
        final mention = mentions[index];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(mention.profileImage),
                    radius: 27.5,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMentionHeader(mention),
                        const SizedBox(height: 2),
                        _buildMentionContent(mention),
                        if (mention.mentionImage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Image.asset(mention.mentionImage),
                          ),
                        const SizedBox(height: 10),
                        _buildMentionActions(mention),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xffCED5DC), thickness: 0.33),
          ],
        );

      },
    );
  }

  Widget _buildMentionHeader(MentionModel mention) {
    return Row(
      children: [
        Text(
          mention.name,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Helveticaneue100',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          mention.username,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff687684),
            fontFamily: 'Helveticaneue100',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "·${mention.date}",
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Helveticaneue100',
            fontWeight: FontWeight.w400,
            color: Color(0xff687684),
            letterSpacing: -0.3,
          ),
        ),
        const Spacer(),
        Image.asset(
          'assets/images/tweet_downarrow.png',
          height: 8,
          width: 10,
        ),
      ],
    );
  }

  Widget _buildMentionContent(MentionModel mention) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mention.mentionText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          mention.taggedUsers,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff4C9EEB),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          mention.articleText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          mention.link,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff4C9EEB),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildMentionActions(MentionModel mention) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem('assets/images/tweet_comment.png', mention.comments),
        _buildActionItem('assets/images/mention_retweet.png', mention.retweets, color: const Color(0xff59BC6C)),
        _buildActionItem('assets/images/mention_like.png', mention.likes, color: const Color(0xffCE395F)),
        Image.asset(
          'assets/images/tweet_share.png',
          height: 15,
          width: 15,
        ), SizedBox(width: 0),
      ],
    );
  }

  Widget _buildActionItem(String icon, int count, {Color? color}) {
    return Row(
      children: [
        Image.asset(icon, height: 15, width: 15),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color ?? const Color(0xff687684),
          ),
        ),
      ],
    );
  }
}
