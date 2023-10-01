import 'package:flutter/material.dart';
import 'package:outwork_web_app/assets/app_color_palette.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TeQRCodeGenerator extends StatelessWidget {
  final String data;

  const TeQRCodeGenerator({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      size: 280,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: TeAppColorPalette.green,
      ),
      // ignore: deprecated_member_use
      foregroundColor: TeAppColorPalette.green,
    );
  }
}
