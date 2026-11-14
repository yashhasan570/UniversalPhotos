import 'package:flutter/material.dart';
import 'package:universal_photos/extensions/build_context_extensions.dart';

class UniversalPhotosTitleText extends StatelessWidget {
  final double fontSize;

  const UniversalPhotosTitleText({super.key, this.fontSize = 48});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(context.isDarkTheme ? 'assets/universalphotos-text-dark.png' : 'assets/universalphotos-text-light.png'),
      width: fontSize * 4,
      filterQuality: FilterQuality.high,
      color: context.primaryColor,
    );
  }
}
