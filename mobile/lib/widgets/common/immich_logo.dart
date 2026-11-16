import 'package:flutter/material.dart';

class UniversalPhotosLogo extends StatelessWidget {
  final double size;

  const UniversalPhotosLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: const AssetImage('assets/universal_photos-logo.png'),
      width: size,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
    );
  }
}
