import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerUtils {
  static Future<BitmapDescriptor> createCustomMarkerBitmap(
    String title,
    int queueWait,
    bool isSelected, {
    bool isOwner = false,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // --- NEW: Get the phone's screen pixel ratio! ---
    final double dpr =
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;

    // --- NEW: Scale the entire canvas so it draws High-Res! ---
    canvas.scale(dpr, dpr);

    // --- NEW: Owner is Blue, Others are based on Queue Wait ---
    Color bgColor;
    if (isOwner) {
      bgColor = Color(0xFF0D47A1);
    } else {
      bgColor = queueWait >= 20
          ? Color(0xFFDC2626)
          : queueWait >= 10
          ? Color(0xFFF97316)
          : Color(0xFF10B981);
    }

    const double radius = 16.0;
    const double textPadding = 5.0;

    TextPainter titlePainter = TextPainter(
      text: TextSpan(
        text: title,
        style: const TextStyle(
          fontSize: 12.0,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final double canvasWidth = titlePainter.width > (radius * 3)
        ? titlePainter.width + 20
        : (radius * 3) + 20;
    final double cx = canvasWidth / 2;
    final double cy = titlePainter.height + textPadding + radius;
    final double tipY = cy + radius * 1.8;
    final double canvasHeight = tipY + 2;

    final double titleX = (canvasWidth - titlePainter.width) / 2;
    final Rect textBgRect = Rect.fromLTWH(
      titleX - 6,
      0,
      titlePainter.width + 12,
      titlePainter.height + 4,
    );
    final RRect rRect = RRect.fromRectAndRadius(
      textBgRect,
      const Radius.circular(8),
    );

    canvas.drawShadow(Path()..addRRect(rRect), Colors.black, 3, true);
    canvas.drawRRect(
      rRect,
      Paint()
        ..color = Colors.white.withOpacity(0.95)
        ..style = PaintingStyle.fill,
    );
    titlePainter.paint(canvas, Offset(titleX, 2));

    Path pinPath = Path()
      ..moveTo(cx, tipY)
      ..quadraticBezierTo(cx - radius, cy + radius * 0.5, cx - radius, cy)
      ..arcToPoint(
        Offset(cx + radius, cy),
        radius: const Radius.circular(radius),
        clockwise: true,
      )
      ..quadraticBezierTo(cx + radius, cy + radius * 0.5, cx, tipY)
      ..close();

    canvas.drawShadow(pinPath, Colors.black, 4, true);
    canvas.drawPath(pinPath, Paint()..color = bgColor);

    if (isSelected) {
      canvas.drawPath(
        pinPath,
        Paint()
          ..color = Colors.blue.shade900
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0,
      );
    }

    canvas.drawCircle(
      Offset(cx, cy),
      radius * 0.65,
      Paint()..color = Colors.white,
    );

    TextPainter queuePainter = TextPainter(
      text: TextSpan(
        text: isOwner ? title[0].toUpperCase() : "${queueWait}Q",
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    queuePainter.paint(
      canvas,
      Offset(cx - (queuePainter.width / 2), cy - (queuePainter.height / 2)),
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      (canvasWidth * dpr).ceil(),
      (canvasHeight * dpr).ceil(),
    );
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> createUserLocationBitmap() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final double dpr =
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    canvas.scale(dpr, dpr); // Scale for high-res screens

    //Larger canvas, centered origin
    const double size = 80.0;
    const double cx = size / 2;
    const double cy = size / 2;

    // Outer soft pulse ring
    canvas.drawCircle(
      const Offset(cx, cy),
      30,
      Paint()
        ..color = Color(0xFF154394).withOpacity(0.15)
        ..style = PaintingStyle.fill,
    );

    // Mid pulse ring
    canvas.drawCircle(
      const Offset(cx, cy),
      22,
      Paint()
        ..color = Color(0xFF154394).withOpacity(0.25)
        ..style = PaintingStyle.fill,
    );

    // Main blue filled circle
    canvas.drawCircle(
      const Offset(cx, cy),
      14,
      Paint()
        ..color = Color(0xFF154394)
        ..style = PaintingStyle.fill,
    );

    // White border stroke
    canvas.drawCircle(
      const Offset(cx, cy),
      14,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );

    // Small white dot in center
    canvas.drawCircle(
      const Offset(cx, cy),
      4,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    // Canvas size matches the declared size
    final ui.Image image = await pictureRecorder.endRecording().toImage(
      (size * dpr).ceil(),
      (size * dpr).ceil(),
    );
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }
}
