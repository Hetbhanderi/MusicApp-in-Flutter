import 'package:flutter/material.dart';
import 'package:musicplayer/constrants/app_colors.dart';

class MButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onpress;
  final EdgeInsetsGeometry? padding;
  final bool isPressed;
  final Color btnBackGround;
  final blurFirstColor;
  final blurSecondColor;

  const MButton({
    super.key,
    required this.child,
    required this.onpress,
    this.padding,
    this.isPressed = false,
    this.btnBackGround = AppColors.blurColor,
    this.blurFirstColor = AppColors.white,
    this.blurSecondColor = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: AnimatedContainer(
        duration: Duration(microseconds: 100),
        padding: padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: blurFirstColor,
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: blurFirstColor,
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: blurFirstColor,
                    offset: Offset(-2, -2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: blurSecondColor,
                    offset: Offset(6, 6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: blurSecondColor,
                    offset: Offset(-6, -6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
