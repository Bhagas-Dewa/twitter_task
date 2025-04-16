import 'package:flutter/material.dart';

String formatTimestamp(DateTime timestamp) {
  final hour = timestamp.hour > 12 ? timestamp.hour - 12 : (timestamp.hour == 0 ? 12 : timestamp.hour);
  final period = timestamp.hour >= 12 ? 'PM' : 'AM';
  final minute = timestamp.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period · ${getMonthAbbr(timestamp.month)} ${timestamp.day}, ${timestamp.year}';
}

String getMonthAbbr(int month) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return months[month - 1];
}

String getTimeAgo(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);
  
  if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  } else {
    return 'just now';
  }
}

Widget buildTweetStat(String label, int count) {
  return Row(
    children: [
      Text(
        '$count',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    ],
  );
}