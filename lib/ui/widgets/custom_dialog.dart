import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/app_theme.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      constraints: BoxConstraints(
        maxWidth: (MediaQuery.of(context).size.width * 0.8).clamp(0.0, 500.0),
      ),
      surfaceTintColor: AppTheme.naturalWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.borderRadiusL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
          color: AppTheme.naturalWhite,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppTheme.spacingM,
          children: [
            SizedBox(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTheme.heading1,
                  color: AppTheme.secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            content,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
