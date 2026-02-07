// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
  id: json['id'] as String,
  title: json['title'] as String,
  emojiClues: (json['emojiClues'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  releaseYear: (json['releaseYear'] as num).toInt(),
  genre: json['genre'] as String,
);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'emojiClues': instance.emojiClues,
  'releaseYear': instance.releaseYear,
  'genre': instance.genre,
};
