import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' as math;
import '../models/level_entities.dart';
import '../models/word_puzzle.dart';
import '../../../../core/storage/objectbox_manager.dart';

abstract class LevelRepository {
  Future<WordPuzzle> getLevel(int levelNumber);
  Future<void> saveProgress(LevelProgress progress);
  Future<List<LevelProgress>> getAllProgress();
  Future<void> saveDiscoveredWord(DiscoveredWord word);
}

class LevelRepositoryImpl implements LevelRepository {
  final ObjectBoxManager _storage;
  List<WordPuzzle>? _cachedLevels;

  LevelRepositoryImpl(this._storage);

  Future<void> _loadAndParseLevels() async {
    if (_cachedLevels != null) return;

    try {
      final content = await rootBundle.loadString('assets/data/levels.txt');
      final lines = content
          .split(RegExp(r'\r?\n'))
          .where((l) => l.trim().isNotEmpty)
          .toList();

      _cachedLevels = lines.map((line) {
        final parts = line.split('|');
        if (parts.length < 3) throw Exception('Invalid line format: $line');

        final level = int.parse(parts[0].trim());
        final letters = parts[1]
            .trim()
            .split('')
            .where((s) => s.trim().isNotEmpty)
            .toList();
        final targetWords = parts[2]
            .split(',')
            .map((s) => s.trim().toUpperCase())
            .where((s) => s.isNotEmpty)
            .toList();

        return WordPuzzle(
          level: level,
          availableLetters: letters,
          targetWords: targetWords,
          timeLimitSeconds: math.max(60, targetWords.length * 15),
        );
      }).toList();
    } catch (e) {
      // Fallback or rethrow
      _cachedLevels = [];
    }
  }

  @override
  Future<WordPuzzle> getLevel(int levelNumber) async {
    await _loadAndParseLevels();

    if (_cachedLevels == null || _cachedLevels!.isEmpty) {
      throw Exception('Failed to load levels from assets');
    }

    final puzzle = _cachedLevels!.firstWhere(
      (p) => p.level == levelNumber,
      orElse: () => _cachedLevels!.first,
    );

    return puzzle;
  }

  @override
  Future<void> saveProgress(LevelProgress progress) async {
    _storage.levelBox.put(progress);
  }

  @override
  Future<List<LevelProgress>> getAllProgress() async {
    return _storage.levelBox.getAll();
  }

  @override
  Future<void> saveDiscoveredWord(DiscoveredWord word) async {
    _storage.wordBox.put(word);
  }
}
