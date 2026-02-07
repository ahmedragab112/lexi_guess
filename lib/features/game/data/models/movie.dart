import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie extends Equatable {
  static const _id = 'id';
  static const _title = 'title';
  static const _emojiClues = 'emojiClues';
  static const _releaseYear = 'releaseYear';
  static const _genre = 'genre';

  final String id;
  final String title;
  final List<String> emojiClues;
  final int releaseYear;
  final String genre;

  const Movie({
    required this.id,
    required this.title,
    required this.emojiClues,
    required this.releaseYear,
    required this.genre,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

  @override
  List<Object?> get props => [id, title, emojiClues, releaseYear, genre];
}
