import 'package:flutter/material.dart';
import '../theme/brutalist_theme.dart';

enum BrutalistButtonVariant {
  primary,
  secondary,
  danger,
  tonal,
}

class BrutalistButton extends StatefulWidget {
  final String? label;
  final VoidCallback onPressed;
  final BrutalistButtonVariant variant;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final Widget? iconWidget;
  final bool fullWidth;
  final bool small;
  final bool isLoading;

  const BrutalistButton({
    super.key,
    this.label,
    required this.onPressed,
    this.variant = BrutalistButtonVariant.primary,
    this.color,
    this.textColor,
    this.icon,
    this.iconWidget,
    this.fullWidth = false,
    this.small = false,
    this.isLoading = false,
  });

  @override
  State<BrutalistButton> createState() => _BrutalistButtonState();
}

class _BrutalistButtonState extends State<BrutalistButton> with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _loadingController;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  Color get _bgColor {
    if (widget.color != null) return widget.color!;
    switch (widget.variant) {
      case BrutalistButtonVariant.primary:
        return MonoColors.amber;
      case BrutalistButtonVariant.secondary:
        return MonoColors.surfaceHigh;
      case BrutalistButtonVariant.danger:
        return MonoColors.danger;
      case BrutalistButtonVariant.tonal:
        return MonoColors.surface;
    }
  }

  Color get _fgColor {
    if (widget.textColor != null) return widget.textColor!;
    switch (widget.variant) {
      case BrutalistButtonVariant.primary:
        return Colors.black;
      case BrutalistButtonVariant.secondary:
        return MonoColors.amber;
      case BrutalistButtonVariant.danger:
        return Colors.white;
      case BrutalistButtonVariant.tonal:
        return MonoColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) _pressed = false;
    final bgColor = _bgColor;
    final fgColor = _fgColor;

    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.isLoading
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onPressed();
            },
      onTapCancel: widget.isLoading ? null : () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: widget.small ? MonoSpacing.base : MonoSpacing.xl,
          vertical: widget.small ? MonoSpacing.sm : MonoSpacing.md,
        ),
        decoration: BoxDecoration(
          color: widget.isLoading ? bgColor.withValues(alpha: 0.7) : bgColor,
          border: Border.all(color: Colors.black, width: MonoDecor.borderWidth),
          boxShadow: (_pressed || widget.isLoading)
              ? []
              : [
                  const BoxShadow(
                    color: Colors.black54,
                    offset: Offset(MonoDecor.shadowOffset, MonoDecor.shadowOffset),
                    blurRadius: 0,
                  ),
                ],
        ),
        transform: (_pressed || widget.isLoading)
            ? Matrix4.translationValues(
                MonoDecor.shadowOffset, MonoDecor.shadowOffset, 0)
            : Matrix4.identity(),
        child: Row(
          mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading)
              FadeTransition(
                opacity: _loadingController,
                child: Text(
                  'LOADING...',
                  style: (widget.small ? MonoText.label : MonoText.labelLg)
                      .copyWith(color: fgColor, letterSpacing: 2),
                ),
              )
            else ...[
              if (widget.iconWidget != null) ...[
                widget.iconWidget!,
                Gap.hSm,
              ] else if (widget.icon != null) ...[
                Icon(widget.icon, color: fgColor, size: widget.small ? 18 : 22),
                Gap.hSm,
              ],
              if (widget.label != null && widget.label!.isNotEmpty) ...[
                if (widget.iconWidget != null || widget.icon != null) Gap.hSm,
                Text(
                  widget.label!.toUpperCase(),
                  style: (widget.small ? MonoText.label : MonoText.labelLg)
                      .copyWith(color: fgColor),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class TileButton extends StatefulWidget {
  final String label;
  final String? subtitle;
  final IconData icon;
  final BrutalistButtonVariant variant;
  final Color? color;
  final VoidCallback onPressed;

  const TileButton({
    super.key,
    required this.label,
    this.subtitle,
    required this.icon,
    this.variant = BrutalistButtonVariant.secondary,
    this.color,
    required this.onPressed,
  });

  @override
  State<TileButton> createState() => _TileButtonState();
}

class _TileButtonState extends State<TileButton> {
  bool _pressed = false;

  Color get _bgColor {
    if (widget.color != null) return widget.color!;
    switch (widget.variant) {
      case BrutalistButtonVariant.primary:
        return MonoColors.amber;
      case BrutalistButtonVariant.secondary:
        return MonoColors.surfaceHigh;
      case BrutalistButtonVariant.danger:
        return MonoColors.danger;
      case BrutalistButtonVariant.tonal:
        return MonoColors.surface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _bgColor;
    final fgColor = widget.variant == BrutalistButtonVariant.primary ? Colors.black : MonoColors.textPrimary;
    final iconColor = widget.variant == BrutalistButtonVariant.primary ? Colors.black : MonoColors.amber;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: double.infinity,
        padding: const EdgeInsets.all(MonoSpacing.xl),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: Colors.black, width: MonoDecor.borderWidth),
          boxShadow: _pressed
              ? []
              : [
                  const BoxShadow(
                    color: Colors.black54,
                    offset: Offset(MonoDecor.shadowOffset, MonoDecor.shadowOffset),
                    blurRadius: 0,
                  ),
                ],
        ),
        transform: _pressed
            ? Matrix4.translationValues(
                MonoDecor.shadowOffset, MonoDecor.shadowOffset, 0)
            : Matrix4.identity(),
        child: Row(
          children: [
            Icon(widget.icon, color: iconColor, size: 28),
            Gap.hBase,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label.toUpperCase(),
                    style: MonoText.labelLg.copyWith(color: fgColor),
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: MonoText.bodySm.copyWith(color: fgColor.withValues(alpha: 0.7)),
                    ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: iconColor, size: 24),
          ],
        ),
      ),
    );
  }
}
