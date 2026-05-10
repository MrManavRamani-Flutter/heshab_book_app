// lib/core/constants/app_text_styles.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display ────────────────────────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.outfit(
    fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );
  static TextStyle displayMedium = GoogleFonts.outfit(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  // ── Headings ───────────────────────────────────────────────────────────────
  static TextStyle h1 = GoogleFonts.outfit(
    fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );
  static TextStyle h2 = GoogleFonts.outfit(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle h3 = GoogleFonts.outfit(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle h4 = GoogleFonts.outfit(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  // ── Body ───────────────────────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.outfit(
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle bodyMedium = GoogleFonts.outfit(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle bodySmall = GoogleFonts.outfit(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  // ── Labels ─────────────────────────────────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.outfit(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary,
  );
  static TextStyle labelMedium = GoogleFonts.outfit(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
  );
  static TextStyle labelSmall = GoogleFonts.outfit(
    fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textHint,
  );

  // ── Financial Amounts ──────────────────────────────────────────────────────
  static TextStyle amountLarge = GoogleFonts.outfit(
    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );
  static TextStyle amountMedium = GoogleFonts.outfit(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle amountSmall = GoogleFonts.outfit(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary,
  );

  // ── Button ─────────────────────────────────────────────────────────────────
  static TextStyle buttonLarge = GoogleFonts.outfit(
    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,
  );
  static TextStyle buttonMedium = GoogleFonts.outfit(
    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
  );

  // ── Caption / Hint ─────────────────────────────────────────────────────────
  static TextStyle caption = GoogleFonts.outfit(
    fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textHint,
  );
}
