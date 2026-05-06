import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  AppStyles._();

  // ─── Font Family ───────────────────────────────────────────────────────────
  static const String _fontFamily = 'Open Sans';

  // ─── Titles ────────────────────────────────────────────────────────────────



  // ----------- Like _______________________

  static double get standardHeight => 56.h;

  /// Title-1 — fontSize: 72, lineHeight: 88, letterSpacing: -0.8
  static TextStyle title1({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 72.sp,
      height: 88 / 72,
      letterSpacing: letterSpacing ?? -0.8,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// Title-2 — fontSize: 64, lineHeight: 76, letterSpacing: -0.8
  static TextStyle title2({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 64.sp,
      height: 76 / 64,
      letterSpacing: letterSpacing ?? -0.8,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// Title-3 — fontSize: 56, lineHeight: 68, letterSpacing: -0.6
  static TextStyle title3({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 56.sp,
      height: 68 / 56,
      letterSpacing: letterSpacing ?? -0.6,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  // ─── Headings ──────────────────────────────────────────────────────────────

  /// H1 — fontSize: 56, lineHeight: 68, letterSpacing: -0.5
  static TextStyle h1({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 56.sp,
      height: 68 / 56,
      letterSpacing: letterSpacing ?? -0.5,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// H2 — fontSize: 48, lineHeight: 58, letterSpacing: -0.4
  static TextStyle h2({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 48.sp,
      height: 58 / 48,
      letterSpacing: letterSpacing ?? -0.4,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// H3 — fontSize: 40, lineHeight: 48, letterSpacing: -0.3
  static TextStyle h3({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 40.sp,
      height: 48 / 40,
      letterSpacing: letterSpacing ?? -0.3,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// H4 — fontSize: 32, lineHeight: 38, letterSpacing: -0.2
  static TextStyle h4({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 32.sp,
      height: 38 / 32,
      letterSpacing: letterSpacing ?? -0.2,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// H5 — fontSize: 24, lineHeight: 30, letterSpacing: -0.15
  static TextStyle h5({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 24.sp,
      height: 30 / 24,
      letterSpacing: letterSpacing ?? -0.15,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// H6 — fontSize: 20, lineHeight: 24, letterSpacing: 0
  static TextStyle h6({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 20.sp,
      height: 24 / 20,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  // ─── Body ──────────────────────────────────────────────────────────────────

  /// Body-1 — fontSize: 18, lineHeight: 28, letterSpacing: 0
  static TextStyle body1({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 18.sp,
      height: 28 / 18,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// Body-2 — fontSize: 16, lineHeight: 24, letterSpacing: 0
  static TextStyle body2({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 16.sp,
      height: 24 / 16,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// Body-3 — fontSize: 14, lineHeight: 20, letterSpacing: 0
  static TextStyle body3({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 14.sp,
      height: 20 / 14,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// Body-4 — fontSize: 12, lineHeight: 16, letterSpacing: 0
  static TextStyle body4({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 12.sp,
      height: 16 / 12,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  // ─── Captions ──────────────────────────────────────────────────────────────

  /// Caption-1 — fontSize: 10, lineHeight: 12, letterSpacing: 0
  static TextStyle caption1({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 10.sp,
      height: 12 / 10,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  /// Caption-2 — fontSize: 9, lineHeight: 10, letterSpacing: 0
  static TextStyle caption2({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontFamily: _fontFamily,
      fontSize: 9.sp,
      height: 10 / 9,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }
}