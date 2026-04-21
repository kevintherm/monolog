import 'package:flutter/material.dart';
import '../theme/brutalist_theme.dart';

class BrutalistButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool fullWidth;
  final bool small;
  final bool isLoading;

  const BrutalistButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.textColor,
    this.icon,
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

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) _pressed = false;
    final bgColor = widget.color ?? MonoColors.amber;
    final fgColor = widget.textColor ?? Colors.black;

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
              if (widget.icon != null) ...[
                Icon(widget.icon, color: fgColor, size: widget.small ? 18 : 22),
                Gap.hSm,
              ],
              Text(
                widget.label.toUpperCase(),
                style: (widget.small ? MonoText.label : MonoText.labelLg)
                    .copyWith(color: fgColor),
              ),
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
  final Color color;
  final VoidCallback onPressed;

  const TileButton({
    super.key,
    required this.label,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  State<TileButton> createState() => _TileButtonState();
}

class _TileButtonState extends State<TileButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
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
          color: widget.color,
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
            Icon(widget.icon, color: Colors.black, size: 28),
            Gap.hBase,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label.toUpperCase(),
                    style: MonoText.labelLg.copyWith(color: Colors.black),
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: MonoText.bodySm.copyWith(color: Colors.black87),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.black, size: 24),
          ],
        ),
      ),
    );
  }
}
