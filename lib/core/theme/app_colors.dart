// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // ── Dark Theme Palette ─────────────────────────────────────────────────────
  static const Color background = Color(0xFF0F0F12);
  static const Color surface = Color(0xFF1A1A22);
  static const Color surfaceLight = Color(0xFF252530);
  
  // ── Primary & Accents ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6366F1);      // Indigo / Electric Blue
  static const Color secondary = Color(0xFF8B5CF6);    // Violet
  static const Color accent = Color(0xFF10B981);       // Emerald (Success)
  static const Color warning = Color(0xFFF59E0B);      // Amber
  static const Color danger = Color(0xFFEF4444);       // Rose (Error)
  
  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textHint = Color(0xFF475569);

  // ── Financial Colors ───────────────────────────────────────────────────────
  static const Color profit = Color(0xFF10B981);
  static const Color loss = Color(0xFFEF4444);
  static const Color receivable = Color(0xFF6366F1);
  static const Color payable = Color(0xFFEF4444);
  static const Color error = Color(0xFFEF4444);
  
  // ── Glassmorphism ──────────────────────────────────────────────────────────
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassSurface = Color(0x1AFFFFFF);
  
  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
