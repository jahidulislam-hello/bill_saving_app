
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vyzi/core/utils/app_styles.dart';

import '../utils/app_colors.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<CountryCode>? onCountryChanged;
  final String? initialSelection;
  final String? labelText;

  const PhoneTextField({
    super.key,
    required this.controller,
    this.onCountryChanged,
    this.initialSelection = 'IT',
    this.labelText,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
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
    final double fieldHeight = AppStyles.standardHeight;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: _isFocused ? AppColors.primaryColor : AppColors.neutral200,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.labelText != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Text(
                widget.labelText!,
                style: AppStyles.caption.copyWith(
                  color: _isFocused ? AppColors.primaryColor : AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Country Picker ─────────────────
              SizedBox(
                height: 40.h,
                child: CountryCodePicker(
                  onChanged: widget.onCountryChanged,
                  initialSelection: widget.initialSelection,
                  favorite: const ['+39', 'IT'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  padding: EdgeInsets.zero,
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // ── Phone Number Field ─────────────
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  cursorColor: AppColors.primaryColor,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Numero di telefono',
                    hintStyle: TextStyle(
                      color: AppColors.hintColor,
                      fontSize: 14.sp,
                    ),
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
