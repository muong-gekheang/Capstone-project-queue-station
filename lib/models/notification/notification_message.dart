class NotificationSpan {
  final String text;
  final bool isHighlighted;

  const NotificationSpan(this.text, {this.isHighlighted = false});
}

class NotificationMessage {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime receivedAt;
  bool isRead;

  /// Optional image URL (e.g. restaurant logo) shown on the left of the tile.
  final String? imageUrl;

  /// Rich text lines. Each inner list is one display line made up of spans.
  /// When non-null, this overrides [body] for tile rendering.
  final List<List<NotificationSpan>>? richLines;

  NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.receivedAt,
    this.isRead = false,
    this.imageUrl,
    this.richLines,
  });
}
