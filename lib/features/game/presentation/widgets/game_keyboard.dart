import 'package:flutter/material.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';

class GameKeyboard extends StatelessWidget {
  final Function(String) onKeyTap;
  final Set<String> revealedLetters;
  final String movieTitle;

  const GameKeyboard({
    super.key,
    required this.onKeyTap,
    required this.revealedLetters,
    required this.movieTitle,
  });

  @override
  Widget build(BuildContext context) {
    const keys = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            final isGuessed = revealedLetters.contains(key);
            final isInTitle = movieTitle.toUpperCase().contains(key);

            Color bgColor = Colors.white.withValues(alpha:0.05);
            if (isGuessed) {
              bgColor = isInTitle
                  ? AppColors.success.withValues(alpha:0.5)
                  : AppColors.error.withValues(alpha:0.5);
            }

            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: InkWell(
                onTap: () => onKeyTap(key),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 30,
                  height: 45,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
