class FeedbackItem {
  final String feedback;
  final String reply;
  final int feedbackId;

  FeedbackItem({
    required this.feedback,
    required this.reply,
    required this.feedbackId,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      feedback: json['feedback'] as String,
      reply: json['reply'] as String,
      feedbackId: json['feedbackid'] as int,
    );
  }
}
