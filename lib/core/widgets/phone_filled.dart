import 'package:vyzi/core/utils/app_style.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<CountryCode>? onCountryChanged;
  final String? initialSelection;

  const PhoneTextField({
    super.key,
    required this.controller,
    this.onCountryChanged,
    this.initialSelection = 'IT',
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _border({Color? color}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: BorderSide(
      color: color ?? AppColors.neutral200,
      width: 1.2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final double fieldHeight = AppStyles.standardHeight;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Country Picker ─────────────────
        Container(
          height: fieldHeight,
          decoration: BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.neutral200,
              width: 1.2,
            ),
          ),
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
              fontFamily: 'Open Sans',
            ),
          ),
        ),
        SizedBox(width: 8.w),

        // ── Phone Number Field ─────────────
        Expanded(
          child: SizedBox(
            height: fieldHeight,
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              cursorColor: AppColors.primaryColor,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontFamily: 'Open Sans',
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Numero di telefono',
                hintStyle: TextStyle(
                  color: AppColors.hintColor,
                  fontFamily: 'Open Sans',
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: AppColors.fillColor,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                border: _border(color: AppColors.neutral200),
                enabledBorder: _border(color: AppColors.neutral200),
                focusedBorder: _border(color: AppColors.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
