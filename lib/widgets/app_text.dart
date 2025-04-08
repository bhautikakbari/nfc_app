import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTextType {
  headline1,
  headline2,
  headline3,
  headline4,
  headline5,
  headline6,
  subtitle1,
  subtitle2,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
  button,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextType type;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool selectable;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? letterSpacing;
  final double? lineHeight;
  final TextDecoration? decoration;

  const AppText(
      this.text, {
        super.key,
        this.type = AppTextType.bodyMedium,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.selectable = false,
        this.fontWeight,
        this.fontSize,
        this.letterSpacing,
        this.lineHeight,
        this.decoration,
      });

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = _getBaseStyle(context);
    final TextStyle style = baseStyle.copyWith(
      color: color ?? baseStyle.color,
      fontWeight: fontWeight ?? baseStyle.fontWeight,
      fontSize: fontSize ?? baseStyle.fontSize,
      letterSpacing: letterSpacing ?? baseStyle.letterSpacing,
      height: lineHeight,
      decoration: decoration,
    );

    if (selectable) {
      return SelectableText(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getBaseStyle(BuildContext context) {
    final theme = Theme.of(context);

    switch (type) {
      case AppTextType.headline1:
        return GoogleFonts.poppins(textStyle: theme.textTheme.displayLarge!);
      case AppTextType.headline2:
        return GoogleFonts.poppins(textStyle: theme.textTheme.displayMedium!);
      case AppTextType.headline3:
        return GoogleFonts.poppins(textStyle: theme.textTheme.displaySmall!);
      case AppTextType.headline4:
        return GoogleFonts.poppins(textStyle: theme.textTheme.headlineMedium!);
      case AppTextType.headline5:
        return GoogleFonts.poppins(textStyle: theme.textTheme.headlineSmall!);
      case AppTextType.headline6:
        return GoogleFonts.poppins(textStyle: theme.textTheme.titleLarge!);
      case AppTextType.subtitle1:
        return GoogleFonts.poppins(textStyle: theme.textTheme.titleMedium!);
      case AppTextType.subtitle2:
        return GoogleFonts.poppins(textStyle: theme.textTheme.titleSmall!);
      case AppTextType.bodyLarge:
        return GoogleFonts.poppins(textStyle: theme.textTheme.bodyLarge!);
      case AppTextType.bodyMedium:
        return GoogleFonts.poppins(textStyle: theme.textTheme.bodyMedium!);
      case AppTextType.bodySmall:
        return GoogleFonts.poppins(textStyle: theme.textTheme.bodySmall!);
      case AppTextType.caption:
        return GoogleFonts.poppins(textStyle: theme.textTheme.bodySmall!.copyWith(
          fontSize: 12,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ));
      case AppTextType.button:
        return GoogleFonts.poppins(textStyle: theme.textTheme.labelLarge!);
    }
  }
}
