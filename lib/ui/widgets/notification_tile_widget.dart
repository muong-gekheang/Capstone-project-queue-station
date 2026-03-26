import 'package:flutter/material.dart';
import 'package:queue_station_app/models/notification/notification_message.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';

class NotificationTileWidget extends StatelessWidget {
  final NotificationMessage notification;

  const NotificationTileWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.white
                : AppTheme.primaryColor.withValues(alpha: 0.05),
            border: Border.all(
              width: 1,
              color: notification.isRead
                  ? AppTheme.naturalBlack.withValues(alpha: 0.15)
                  : AppTheme.primaryColor.withValues(alpha: 0.4),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.imageUrl != null &&
                  notification.imageUrl!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    notification.imageUrl!,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderIcon(),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (notification.title.isNotEmpty)
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.naturalBlack,
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (notification.richLines != null &&
                        notification.richLines!.isNotEmpty)
                      ..._buildRichLines(notification.richLines!)
                    else if (notification.body.isNotEmpty)
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.naturalBlack.withValues(alpha: 0.7),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(notification.receivedAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.naturalBlack.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!notification.isRead)
          Positioned(
            top: -10,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                'New',
                style: TextStyle(
                  color: AppTheme.naturalWhite,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildRichLines(List<List<NotificationSpan>> richLines) {
    return richLines.map((spans) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: RichText(
          text: TextSpan(
            children: spans.map((span) {
              return TextSpan(
                text: span.text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: span.isHighlighted
                      ? FontWeight.w700
                      : FontWeight.normal,
                  color: span.isHighlighted
                      ? AppTheme.primaryColor
                      : AppTheme.naturalBlack.withValues(alpha: 0.7),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }).toList();
  }

  Widget _placeholderIcon() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.restaurant,
        color: AppTheme.primaryColor,
        size: 28,
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
