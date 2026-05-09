// lib/core/constants/app_text_styles.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display ────────────────────────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary,
  );
  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary,
  );

  // ── Headings ───────────────────────────────────────────────────────────────
  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary,
  );
  static TextStyle h2 = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary,
  );
  static TextStyle h3 = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary,
  );
  static TextStyle h4 = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary,
  );

  // ── Body ───────────────────────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.lightTextPrimary,
  );
  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.lightTextPrimary,
  );
  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.lightTextSecondary,
  );

  // ── Labels ─────────────────────────────────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary,
  );
  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.lightTextSecondary,
  );
  static TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.lightTextHint,
  );

  // ── Financial Amounts ──────────────────────────────────────────────────────
  static TextStyle amountLarge = GoogleFonts.poppins(
    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary,
  );
  static TextStyle amountMedium = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary,
  );
  static TextStyle amountSmall = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary,
  );

  // ── Button ─────────────────────────────────────────────────────────────────
  static TextStyle buttonLarge = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,
  );
  static TextStyle buttonMedium = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
  );

  // ── Caption / Hint ─────────────────────────────────────────────────────────
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.lightTextHint,
  );
}
