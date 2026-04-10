import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AvatarSquare extends StatelessWidget {
  final String? imagePathOrUrl;
  final double size;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final String? fallbackText;
  final double fallbackTextSize;
  final FontWeight fallbackTextWeight;
  final String? fallbackAssetPath;

  const AvatarSquare({
    super.key,
    required this.size,
    this.imagePathOrUrl,
    this.borderRadius = 12,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0x66FFFFFF),
    this.borderWidth = 1,
    this.fallbackText,
    this.fallbackTextSize = 16,
    this.fallbackTextWeight = FontWeight.w800,
    this.fallbackAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final source = imagePathOrUrl?.trim() ?? '';
    if (source.isNotEmpty) {
      if (source.startsWith('http://') || source.startsWith('https://')) {
        return Image.network(
          source,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallbackWidget(),
        );
      }
      if (!kIsWeb) {
        return Image.file(
          File(source),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallbackWidget(),
        );
      }
    }

    if (fallbackAssetPath != null) {
      return Image.asset(
        fallbackAssetPath!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallbackWidget(),
      );
    }

    return _fallbackWidget();
  }

  Widget _fallbackWidget() {
    final text = fallbackText?.trim() ?? '';
    if (text.isNotEmpty) {
      return Center(
        child: Text(
          text[0].toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: fallbackTextSize,
            fontWeight: fallbackTextWeight,
          ),
        ),
      );
    }

    return const Icon(Icons.person, color: Colors.grey);
  }
}
