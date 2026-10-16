import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.radius,
  });

  String get _initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: imageUrl.isEmpty
            ? _fallback
            : _isNetworkImage
            ? Image.network(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _fallback,
              )
            : Image.file(
                File(imageUrl),
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _fallback,
              ),
      ),
    );
  }

  bool get _isNetworkImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  Widget get _fallback => Center(
    child: Text(
      _initials.isEmpty ? '?' : _initials,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: radius * 0.55),
    ),
  );
}
