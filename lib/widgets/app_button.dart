import 'package:cube_timer/utils/dimensions.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  
  const AppButton({ Key? key, required this.onTap, required this.width, required this.text, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        margin: EdgeInsets.all(Dimensions.smallest(2)),
        padding: EdgeInsets.all(Dimensions.smallest(2)),
        height: height,
        width: width,
        color: AppColors.mainColor,
        child: Center(child: AppText(text: text)),
      ),
    );
  }
}