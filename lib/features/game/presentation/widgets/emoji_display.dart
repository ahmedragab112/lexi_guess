import 'package:flutter/material.dart';
import 'package:lexi_guess/core/widgets/glass_container.dart';

class EmojiDisplay extends StatelessWidget {
  final List<String> emojis;

  const EmojiDisplay({super.key, required this.emojis});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: emojis
          .map(
            (emoji) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlassContainer(
                width: 60,
                height: 60,
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
