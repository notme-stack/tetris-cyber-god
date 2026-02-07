import 'package:flutter/material.dart';

class AppColors {
  static const backgroundPrimary = Color(0xFF081028);
  static const surfacePrimary = Color(0xFF101830);
  static const surfaceSecondary = Color(0xFF101848);

  static const accentPlayer = Color(0xFF14FCFC);
  static const accentEnemy = Color(0xFFE03CFC);

  static const stateSuccess = Color(0xFF00D68F);
  static const stateDanger = Color(0xFFFF5A5A);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFFAAB3C2);

  static const effectGlass = Color.fromRGBO(20, 36, 46, 0.6);

  // Lobby palette (approved tokens)
  static const lobbyPrimary = Color(0xFF0DF2F2);
  static const lobbySafe = Color(0xFF10B981);
  static const lobbyHostile = Color(0xFFF59E0B);
  static const lobbyApocalypse = Color(0xFFEF4444);
  static const lobbyBackground = Color(0xFF0A0F0F);
  static const lobbyTextMuted = Color(0xFF94A3B8);
  static const lobbyTextMutedAlt = Color(0xFF64748B);
  static const lobbyCardTint = Color.fromRGBO(15, 23, 42, 0.4);
  static const lobbyCardTintStrong = Color.fromRGBO(15, 23, 42, 0.6);
  static const lobbyGlassBg = Color.fromRGBO(13, 242, 242, 0.05);
  static const lobbyGlassBorder = Color.fromRGBO(13, 242, 242, 0.2);
  static const lobbyPrimarySoft = Color.fromRGBO(13, 242, 242, 0.1);
  static const lobbyPrimaryFaint = Color.fromRGBO(13, 242, 242, 0.3);
  static const lobbyChipBg = Color.fromRGBO(255, 255, 255, 0.05);
  static const lobbyChipBorder = Color.fromRGBO(255, 255, 255, 0.05);

  // Aftermath palette (approved tokens)
  static const aftermathPrimary = Color(0xFFF20DF2);
  static const aftermathBackground = Color(0xFF181118);
  static const aftermathPanel = Color.fromRGBO(39, 27, 39, 0.8);
  static const aftermathPanelBorder = Color.fromRGBO(255, 255, 255, 0.05);
  static const aftermathOverlay = Color.fromRGBO(255, 255, 255, 0.05);
  static const aftermathTextMuted = Color.fromRGBO(255, 255, 255, 0.4);
  static const aftermathTextMutedAlt = Color.fromRGBO(255, 255, 255, 0.6);
  static const aftermathPrimaryGlow = Color.fromRGBO(242, 13, 242, 0.4);
  static const aftermathPrimarySoft = Color.fromRGBO(242, 13, 242, 0.1);
  static const aftermathPrimaryBorder = Color.fromRGBO(242, 13, 242, 0.3);
  static const aftermathCyanGlitch = Color(0xFF00FFFF);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class AppRadii {
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 20.0;
  static const xl = 32.0;
  static const pill = 999.0;
}

class AppDurations {
  static const quick = Duration(milliseconds: 80);
  static const normal = Duration(milliseconds: 120);
  static const slow = Duration(milliseconds: 160);
}

class AppBorders {
  static const thin = 1.0;
  static const thick = 2.0;
}

class AppTypography {
  static const headlineSize = 22.0;
  static const titleSize = 16.0;
  static const bodySize = 14.0;
  static const labelSize = 14.0;
  static const letterSpacingTight = 0.4;
  static const letterSpacingWide = 0.6;
  static const tiny = 10.0;
  static const micro = 9.0;
  static const small = 12.0;
  static const lobbyTitleSpacing = 3.0;
  static const lobbyRankSpacing = 2.5;
}

class AppEffects {
  static const glowRadius = 6.0;
  static const neonGlowBlur = 20.0;
  static const selectedGlowBlur = 15.0;
}

class AppSizes {
  static const iconButton = 48.0;
  static const avatar = 96.0;
  static const badgeHeight = 28.0;
  static const statChipHeight = 64.0;
  static const threatCardHeight = 200.0;
  static const cardTopPadding = 12.0;
  static const iconButtonCompact = 40.0;
  static const avatarCompact = 72.0;
  static const lobbyAvatar = 72.0;
  static const lobbyIcon = 40.0;
  static const lobbyBadgeHeight = 22.0;
}

class AppOpacity {
  static const subtle = 0.7;
  static const faint = 0.5;
}
