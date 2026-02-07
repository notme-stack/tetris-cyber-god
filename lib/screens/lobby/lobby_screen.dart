import 'package:flutter/material.dart';
import '../../config/tokens.dart';
import '../../widgets/primary_button.dart';
import '../../services/storage_service.dart';
import '../../services/game_settings.dart';
import '../../models/game_difficulty.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final StorageService _storage = StorageService();
  int _lastScore = 0;
  String _systemId = '...';
  GameDifficulty _difficulty = GameDifficulty.safe;

  @override
  void initState() {
    super.initState();
    _loadStorage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStorage();
  }

  Future<void> _loadStorage() async {
    final lastScore = await _storage.getLastScore();
    final systemId = await _storage.getSystemId();
    final difficulty = await _storage.getDifficulty();
    if (!mounted) return;
    setState(() {
      _lastScore = lastScore;
      _systemId = systemId;
      _difficulty = _parseDifficulty(difficulty);
      GameSettings.difficulty = _difficulty;
    });
  }

  GameDifficulty _parseDifficulty(String value) {
    switch (value) {
      case 'hostile':
        return GameDifficulty.moderate;
      case 'apocalypse':
        return GameDifficulty.high;
      default:
        return GameDifficulty.safe;
    }
  }

  Future<void> _setDifficulty(GameDifficulty difficulty) async {
    setState(() => _difficulty = difficulty);
    GameSettings.difficulty = difficulty;
    final key = switch (difficulty) {
      GameDifficulty.safe => 'safe',
      GameDifficulty.moderate => 'hostile',
      GameDifficulty.high => 'apocalypse',
    };
    await _storage.setDifficulty(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lobbyBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = (constraints.maxHeight / 800).clamp(0.68, 1.0);
            final compactLayout = constraints.maxHeight < 780;
            final padH = AppSpacing.md * scale;
            final padV = AppSpacing.md * scale;
            final sectionGap = compactLayout
                ? AppSpacing.xs * scale
                : AppSpacing.sm * scale;
            return Padding(
              padding: EdgeInsets.fromLTRB(
                padH,
                padV,
                padH,
                AppSpacing.sm * scale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      SizedBox(width: AppSizes.iconButtonCompact * scale),
                      Expanded(
                        child: Center(
                          child: Text(
                            'LOBBY CONTROL',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  letterSpacing:
                                      AppTypography.letterSpacingWide,
                                  fontSize: AppTypography.titleSize * scale,
                                ),
                          ),
                        ),
                      ),
                      _CircleIconButton(
                        icon: Icons.logout,
                        compact: true,
                        color: AppColors.lobbyPrimary,
                        scale: scale,
                      ),
                    ],
                  ),
                  SizedBox(height: sectionGap),
                  _LobbyOverseerCard(scale: scale),
                  SizedBox(height: sectionGap),
                  _LobbyUserCard(
                    lastScore: _lastScore,
                    systemId: _systemId,
                    scale: scale,
                  ),
                  SizedBox(height: sectionGap),
                  Text(
                    'SELECT THREAT LEVEL',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.lobbyTextMuted,
                      fontSize: AppTypography.bodySize * scale,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs * scale),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, levelConstraints) {
                        final levelGap = compactLayout
                            ? (AppSpacing.xs * 0.5 * scale)
                            : (AppSpacing.xs * scale);
                        final cardHeight =
                            (levelConstraints.maxHeight - (levelGap * 2)) / 3;
                        final tight =
                            compactLayout || cardHeight < (155 * scale);
                        return Column(
                          children: [
                            SizedBox(
                              height: cardHeight,
                              child: _DifficultyCard(
                                title: 'SAFE PROTOCOL',
                                badge: '1.0x',
                                accent: AppColors.lobbySafe,
                                icon: Icons.verified_user,
                                selected: _difficulty == GameDifficulty.safe,
                                onTap: () =>
                                    _setDifficulty(GameDifficulty.safe),
                                description:
                                    'Standard piece velocity. Gravity buffers at maximum efficiency.',
                                scale: scale,
                                tight: tight,
                              ),
                            ),
                            SizedBox(height: levelGap),
                            SizedBox(
                              height: cardHeight,
                              child: _DifficultyCard(
                                title: 'HOSTILE PROTOCOL',
                                badge: '2.5x',
                                accent: AppColors.lobbyHostile,
                                icon: Icons.warning_amber_rounded,
                                selected:
                                    _difficulty == GameDifficulty.moderate,
                                onTap: () =>
                                    _setDifficulty(GameDifficulty.moderate),
                                description:
                                    'Increased data influx. System sync delay imminent.',
                                scale: scale,
                                tight: tight,
                              ),
                            ),
                            SizedBox(height: levelGap),
                            SizedBox(
                              height: cardHeight,
                              child: _DifficultyCard(
                                title: 'APOCALYPSE',
                                badge: '5.0x',
                                accent: AppColors.lobbyApocalypse,
                                icon: Icons.dangerous,
                                selected: _difficulty == GameDifficulty.high,
                                onTap: () =>
                                    _setDifficulty(GameDifficulty.high),
                                description:
                                    'Accelerated system entropy. Total neural overload protocol.',
                                scale: scale,
                                tight: tight,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: sectionGap),
                  PrimaryButton(
                    label: 'INITIATE PROTOCOL',
                    isEmphasized: true,
                    backgroundColor: AppColors.lobbyPrimary,
                    foregroundColor: AppColors.lobbyBackground,
                    borderColor: AppColors.lobbyPrimary,
                    onPressed: () => Navigator.of(context).pushNamed('/arena'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final bool compact;
  final Color color;
  final double scale;

  const _CircleIconButton({
    required this.icon,
    this.compact = false,
    required this.color,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          (compact ? AppSizes.iconButtonCompact : AppSizes.iconButton) * scale,
      height:
          (compact ? AppSizes.iconButtonCompact : AppSizes.iconButton) * scale,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.2),
          width: AppBorders.thin,
        ),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _LobbyOverseerCard extends StatelessWidget {
  final double scale;

  const _LobbyOverseerCard({this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md * scale),
      decoration: BoxDecoration(
        color: AppColors.lobbyGlassBg,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: AppColors.lobbyGlassBorder,
          width: AppBorders.thin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSizes.lobbyIcon * scale,
            height: AppSizes.lobbyIcon * scale,
            decoration: BoxDecoration(
              color: AppColors.lobbyPrimarySoft,
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(
                color: AppColors.lobbyGlassBorder,
                width: AppBorders.thin,
              ),
            ),
            child: const Icon(Icons.memory, color: AppColors.lobbyPrimary),
          ),
          SizedBox(width: AppSpacing.md * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AI OVERSEER PRESENCE',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.lobbyPrimary,
                        letterSpacing: AppTypography.letterSpacingWide,
                        fontSize: AppTypography.tiny * scale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'ID: OVRS_09',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.lobbyPrimary.withOpacity(0.6),
                        fontSize: AppTypography.tiny * scale,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs * scale),
                Text(
                  '\"System integrity at 42%. Are you even trying, mortal? My neural pathways are bored of your linear logic.\"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.textPrimary.withOpacity(0.9),
                    fontSize: AppTypography.small * scale,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LobbyUserCard extends StatelessWidget {
  final int lastScore;
  final String systemId;
  final double scale;

  const _LobbyUserCard({
    required this.lastScore,
    required this.systemId,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.md * scale),
          decoration: BoxDecoration(
            color: AppColors.lobbyCardTint,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            border: Border.all(
              color: AppColors.lobbyPrimarySoft,
              width: AppBorders.thin,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.xs * scale),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: AppSizes.lobbyAvatar * scale,
                    height: AppSizes.lobbyAvatar * scale,
                    decoration: BoxDecoration(
                      color: AppColors.lobbyPrimarySoft,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: AppSizes.lobbyAvatar * scale,
                    height: AppSizes.lobbyAvatar * scale,
                    padding: EdgeInsets.all(AppSpacing.xs * scale),
                    decoration: BoxDecoration(
                      color: AppColors.lobbyCardTintStrong,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.lobbyPrimaryFaint,
                        width: 2.0,
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.lobbyCardTint,
                      child: Icon(Icons.person, color: AppColors.textPrimary),
                    ),
                  ),
                  Positioned(
                    bottom: -AppSpacing.xs * scale,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm * scale,
                        vertical: (AppSpacing.xs * 0.9) * scale,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lobbyPrimary,
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Center(
                        child: Text(
                          'ACTIVE',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: AppTypography.micro * scale,
                                fontWeight: FontWeight.w800,
                                color: AppColors.lobbyBackground,
                                letterSpacing: 0.4,
                                height: 1.1,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg * scale),
              Text(
                'CYBER_USER_01',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  letterSpacing: AppTypography.lobbyTitleSpacing,
                  fontWeight: FontWeight.w700,
                  fontSize: AppTypography.titleSize * scale,
                ),
              ),
              SizedBox(height: AppSpacing.xs * scale),
              Text(
                'RANK: ARCHANGEL',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.lobbyPrimary,
                  fontSize: AppTypography.tiny * scale,
                  letterSpacing: AppTypography.lobbyRankSpacing,
                ),
              ),
              SizedBox(height: AppSpacing.md * scale),
              Row(
                children: [
                  Expanded(
                    child: _LobbyStatChip(
                      label: 'LAST SCORE',
                      value: _formatScore(lastScore),
                      scale: scale,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md * scale),
                  Expanded(
                    child: _LobbyStatChip(
                      label: 'SYSTEM ID',
                      value: systemId,
                      scale: scale,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatScore(int score) {
    final value = score.toString();
    if (value.length <= 3) return value;
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i++) {
      final remaining = value.length - i;
      buffer.write(value[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }
}

class _LobbyStatChip extends StatelessWidget {
  final String label;
  final String value;
  final double scale;

  const _LobbyStatChip({
    required this.label,
    required this.value,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm * scale),
      decoration: BoxDecoration(
        color: AppColors.lobbyChipBg,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: AppColors.lobbyChipBorder,
          width: AppBorders.thin,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: AppTypography.micro * scale,
              letterSpacing: AppTypography.letterSpacingWide,
              color: AppColors.lobbyTextMutedAlt,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xs * scale),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: AppTypography.titleSize * scale,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final String title;
  final String badge;
  final Color accent;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String description;
  final double scale;
  final bool tight;

  const _DifficultyCard({
    required this.title,
    required this.badge,
    required this.accent,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.description,
    this.scale = 1.0,
    this.tight = false,
  });

  @override
  Widget build(BuildContext context) {
    final compact = scale < 0.9 || tight;
    final descriptionLines = compact ? 1 : 2;
    final cardPadding = compact ? AppSpacing.sm * scale : AppSpacing.md * scale;
    final titleSize =
        (compact ? AppTypography.bodySize : AppTypography.titleSize * 0.92) *
        scale;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.lobbyCardTintStrong
                  : AppColors.lobbyCardTint,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              border: Border.all(
                color: selected
                    ? AppColors.lobbyPrimary
                    : AppColors.lobbyChipBorder,
                width: selected ? 2.0 : AppBorders.thin,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.lobbyPrimary.withOpacity(0.3),
                        blurRadius: AppEffects.selectedGlowBlur,
                      ),
                    ]
                  : [],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: (AppSizes.lobbyIcon * 0.9) * scale,
                  height: (AppSizes.lobbyIcon * 0.9) * scale,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    border: Border.all(
                      color: accent.withOpacity(0.3),
                      width: AppBorders.thin,
                    ),
                  ),
                  child: Icon(icon, color: accent),
                ),
                SizedBox(width: AppSpacing.md * scale),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: titleSize,
                                  ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs * scale),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm * scale,
                              vertical: AppSpacing.xs * scale,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppRadii.lg),
                              border: Border.all(
                                color: accent.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              badge,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: accent,
                                    fontSize: AppTypography.tiny * scale,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xs * scale),
                      Text(
                        'RISK ASSESSMENT',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AppTypography.tiny * scale,
                          letterSpacing: AppTypography.letterSpacingWide,
                          color: accent.withOpacity(0.7),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs * scale),
                      Text(
                        description,
                        maxLines: descriptionLines,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.lobbyTextMuted,
                          fontSize:
                              (AppTypography.small * (compact ? 0.88 : 0.95)) *
                              scale,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: AppSpacing.sm * scale,
              right: AppSpacing.sm * scale,
              child: Icon(
                Icons.radio_button_checked,
                color: AppColors.lobbyPrimary,
                size: 18 * scale,
              ),
            ),
        ],
      ),
    );
  }
}
