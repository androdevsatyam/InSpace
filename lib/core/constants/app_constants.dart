import 'package:flutter/material.dart';

abstract final class AppAssets {}

abstract final class AppFonts {
  static const primary = 'Plus Jakarta Sans';
  static const mono = 'JetBrains Mono';
}

abstract final class AppValues {
  static const reclaimableGb = 14.8;
  static const totalStorageGb = 128.0;
  static const usedStorageGb = 96.8;
  static const reclaimableItems = 12;
}

abstract final class AppRoutes {
  static const home = '/';
}

abstract final class AppSpacing {
  static const page = 16.0;
  static const card = 16.0;
  static const grid = 6.0;
  static const radius = 18.0;
}

abstract final class AppBreakpoints {
  static const tablet = 700.0;
  static const desktop = 1100.0;
}

abstract final class AppColors {
  static const background = Color(0xFF0B0F19);
  static const card = Color(0xFF111827);
  static const elevated = Color(0xFF1F2937);
  static const border = Color(0xFF374151);
  static const indigo = Color(0xFF6366F1);
  static const emerald = Color(0xFF10B981);
  static const blue = Color(0xFF3B82F6);
  static const amber = Color(0xFFF59E0B);
  static const muted = Color(0xFF94A3B8);
}
