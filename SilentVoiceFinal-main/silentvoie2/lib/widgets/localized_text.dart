import 'package:flutter/material.dart';
import '../l10n/app_localization.dart';

class LocalizedText extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;

  const LocalizedText({
    super.key,
    required this.textKey,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)?.translate(textKey) ?? textKey,
      style: style,
      textAlign: textAlign,
    );
  }
}