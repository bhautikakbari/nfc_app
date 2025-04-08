import 'package:flutter/material.dart';
import 'package:nfc_app/widgets/app_text.dart';

enum AppButtonType {
  primary,
  secondary,
  outlined,
  text,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;

    switch (type) {
      case AppButtonType.primary:
        return _buildElevatedButton(
          context,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white, // Always use white text on primary color
          disabledBackgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
          disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
        );
      case AppButtonType.secondary:
        return _buildElevatedButton(
          context,
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.brightness == Brightness.dark
              ? Colors.black
              : Colors.white, // Ensure good contrast
          disabledBackgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
          disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
        );
      case AppButtonType.outlined:
        return _buildOutlinedButton(context);
      case AppButtonType.text:
        return _buildTextButton(context);
    }
  }

  Widget _buildElevatedButton(
      BuildContext context, {
        required Color backgroundColor,
        required Color foregroundColor,
        required Color disabledBackgroundColor,
        required Color disabledForegroundColor,
      }) {
    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: backgroundColor.withOpacity(0.4),
        ),
        child: _buildButtonContent(foregroundColor),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height ?? 50,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        ),
        child: _buildButtonContent(theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height ?? 50,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        ),
        child: _buildButtonContent(theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildButtonContent(Color foregroundColor) {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          AppText(
            text,
            type: AppTextType.button,
            color: foregroundColor,
          ),
        ],
      );
    }

    return AppText(
      text,
      type: AppTextType.button,
      color: foregroundColor,
    );
  }
}
