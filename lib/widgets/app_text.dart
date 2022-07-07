import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final bool bold;
  final bool shadow;

  const AppText({ Key? key,
    this.color = AppColors.fontLightColor,
    required this.text,
    this.size = 20,
    this.bold = false,
    this.shadow = false,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        fontSize: size,
        shadows: [
          if (shadow)
          Shadow(
            blurRadius: 1.0,
            color: AppColors.mainColor,
            offset: Offset(size*0.05, size*0.05),
          )
        ]
      ),
    );
  }

  void doStuff() {
    
  }
}