enum AiMessageRole {
  user,
  assistant,
}

class AiMessage {
  final String id;
  final String text;
  final AiMessageRole role;
  final DateTime createdAt;

  AiMessage({
    required this.id,
    required this.text,
    required this.role,
    required this.createdAt,
  });
}
