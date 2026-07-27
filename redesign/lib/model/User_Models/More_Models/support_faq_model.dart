class FaqItemModel {
  final String id;
  final String category;
  final String question;
  final String answer;
  int helpfulCount;
  int unhelpfulCount;
  bool isExpanded;

  FaqItemModel({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    this.helpfulCount = 0,
    this.unhelpfulCount = 0,
    this.isExpanded = false,
  });
}

class SupportTicketModel {
  final String ticketId;
  final String category;
  final String subject;
  final String description;
  final DateTime createdAt;
  final String status; // 'OPEN', 'IN_PROGRESS', 'RESOLVED'

  SupportTicketModel({
    required this.ticketId,
    required this.category,
    required this.subject,
    required this.description,
    required this.createdAt,
    this.status = 'OPEN',
  });
}
