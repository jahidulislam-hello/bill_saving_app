
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
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: widget.fillColor ?? AppColors.fillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: _isFocused
                  ? AppColors.primaryColor
                  : (widget.borderColor ?? AppColors.neutral200),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.labelText != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
                  child: Text(
                    widget.labelText!,
                    style: AppStyles.caption.copyWith(
                      color: _isFocused ? AppColors.primaryColor : AppColors.textSecondary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
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
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.contentPaddingH ?? 14.w,
                    vertical: widget.contentPaddingV ?? 8.h,
                  ),
                  filled: false,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.isPassword
                      ? GestureDetector(
                          onTap: () => setState(() => _obscure = !_obscure),
                          child: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                        )
                      : widget.suffixIcon,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: AppColors.hintColor,
                    fontSize: 14.sp,
                  ),
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
