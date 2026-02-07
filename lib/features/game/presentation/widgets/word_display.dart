import 'package:flutter/material.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
class WordDisplay extends StatelessWidget {
  final String title;
  final Set<String> revealedLetters;

  const WordDisplay({
    super.key,
    required this.title,
    required this.revealedLetters,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 12,
      children: title.split('').map((char) {
        if (char == ' ') {
          return const SizedBox(width: 20);
        }

        final isRevealed = revealedLetters.contains(char.toUpperCase());
        return Container(
          width: 35,
          height: 45,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isRevealed ? AppColors.primary : AppColors.textMuted,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              isRevealed ? char.toUpperCase() : '',
              style: AppTextStyles.letterSlot,
            ),
          ),
        );
      }).toList(),
    );
  }
}
