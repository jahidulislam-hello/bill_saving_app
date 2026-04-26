import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class AppStyles {
  // Head title: the largest front size
  static TextStyle headTitle(
      {Color? color, FontWeight? fontWeight, double? letterSpacing}) {
    return TextStyle(
        color: color,
        fontSize: 24.sp,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w600);
  }

  // Field Title: Smaller size 10-12, bold
  static TextStyle fieldTitle(
      {Color? color, FontWeight? fontWeight, double? letterSpacing}) {
    return TextStyle(
        color: color,
        fontSize: 16.sp,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w600);
  }

  // Field Content: same size as title, but not bold
  static TextStyle fieldContent(
      {Color? color, FontWeight? fontWeight, double? letterSpacing}) {
    return TextStyle(
        color: color,
        fontSize: 12.sp,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle fontSize24(
      {Color? color, FontWeight? fontWeight, double? letterSpacing}) {
    return TextStyle(
        color: color,
        fontSize: 24.sp,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle fontSize20(
      {Color? color, FontWeight? fontWeight, double? letterSpacing}) {
    return TextStyle(
        color: color,
        fontSize: 20.sp,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle fontSize18({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,

  }) {
    return TextStyle(
        color: color,
        fontSize: 18.sp,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle fontSize16(
      {Color? color,
        FontWeight? fontWeight,
        double? letterSpacing,
        double? height}) {
    return TextStyle(
        fontSize: 16.sp,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle fontSize14(
      {Color? color,
        FontWeight? fontWeight,
        double? letterSpacing,
        double? height}) {
    return TextStyle(
        fontSize: 14.sp,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle fontSize12(
      {Color? color,
        FontWeight? fontWeight,
        double? letterSpacing,
        double? height}) {
    return TextStyle(
        fontSize: 12.sp,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle fontSize10(
      {Color? color,
        FontWeight? fontWeight,
        double? letterSpacing,
        double? height}) {
    return TextStyle(
        fontSize: 10.sp,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle customSize(
      {Color? color,
        required double size,
        String? family,
        double? letterSpacing,
        double? height,
        FontWeight? fontWeight}) {
    return TextStyle(
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static BoxShadow boxShadow =  BoxShadow(
      blurRadius: 4,
      offset: const Offset(0,0),
      color:Colors.black.withOpacity(0.02),
      spreadRadius:0);

  // Standard UI component height
  static double get standardHeight => 54.h;
}