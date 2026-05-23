import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFF9400D3),
    this.borderColor = Colors.transparent,
    required this.onPress,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      fontFamily: 'Open Sans',
    ),
    this.prefixWidget,
    this.borderRadius,
  });

  final String title;
  final Color backgroundColor;
  final Color? borderColor;
  final TextStyle textStyle;
  final VoidCallback onPress;
  final Widget? prefixWidget;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 12.r;
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      elevation: 0,
      child: InkWell(
        splashColor: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radius),
        onTap: onPress,
        child: Container(
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: borderColor != null && borderColor != Colors.transparent
                ? Border.all(color: borderColor!, width: 1.2)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixWidget != null) ...[
                prefixWidget!,
                SizedBox(width: 10.w),
              ],
              Text(title, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
