
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vyzi/core/utils/app_styles.dart';

import '../utils/app_colors.dart';




// ─────────────────────────────────────────────
//  Custom Text Field
// ─────────────────────────────────────────────
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool? readOnly;
  final Color? fillColor;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingH;
  final double? contentPaddingV;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Color? borderColor;
  final double? height;

  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false,
    this.fillColor,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.hintText,
    this.contentPaddingH,
    this.contentPaddingV,
    this.validator,
    this.onChanged,
    this.onTap,
    this.borderColor,
    this.height,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  OutlineInputBorder _border({Color? color}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: BorderSide(
      color: color ?? widget.borderColor ?? AppColors.neutral200,
      width: 1.2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final double fieldHeight = widget.height ?? AppStyles.standardHeight;
    return SizedBox(
      height: fieldHeight,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscure : false,
        obscuringCharacter: '•',
        maxLines: widget.maxLines,
        readOnly: widget.readOnly ?? false,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        validator: widget.validator,
        cursorColor: AppColors.primaryColor,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
          fontFamily: 'Open Sans',
          height: 1.2,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.contentPaddingH ?? 14.w,
            vertical: widget.contentPaddingV ?? 16.h,
          ),
          filled: true,
          fillColor: widget.fillColor ?? AppColors.fillColor,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? GestureDetector(
            onTap: () => setState(() => _obscure = !_obscure),
            child: Icon(
              _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
          )
              : widget.suffixIcon,
          prefixIconConstraints: BoxConstraints(
            minHeight: fieldHeight,
            minWidth: 48.w,
            maxHeight: fieldHeight,
            maxWidth: 64.w,
          ),
          suffixIconConstraints: BoxConstraints(
            minHeight: fieldHeight,
            minWidth: 48.w,
            maxHeight: fieldHeight,
            maxWidth: 56.w,
          ),
          hintText: widget.hintText,
          labelText: widget.labelText,
          hintStyle: TextStyle(
            color: AppColors.hintColor,
            fontFamily: 'Open Sans',
            fontSize: 14.sp,
          ),
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          border: _border(color: AppColors.neutral200),
          enabledBorder: _border(color: AppColors.neutral200),
          focusedBorder: _border(color: AppColors.primaryColor),
          errorBorder: _border(color: Colors.red),
          disabledBorder: _border(color: AppColors.neutral200),
        ),
      ),
    );
  }
}
