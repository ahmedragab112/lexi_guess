import '../models/movie.dart';

abstract class MovieRepository {
  Future<Movie> getDailyChallenge();
  Future<List<Movie>> getPopularMovies();
}

class MovieRepositoryImpl implements MovieRepository {
  @override
  Future<Movie> getDailyChallenge() async {
    
    await Future.delayed(const Duration(milliseconds: 800));
    return const Movie(
      id: '1',
      title: 'DANGAL',
      emojiClues: ['🤼‍♂️', '🥇', '👨‍👧‍👧', '🇮🇳'],
      releaseYear: 2016,
      genre: 'Sports/Drama',
    );
  }

  @override
  Future<List<Movie>> getPopularMovies() async {
    return [
      const Movie(
        id: '2',
        title: 'SHOLAY',
        emojiClues: ['👮‍♂️', '🔫', '🚂', '🏜️'],
        releaseYear: 1975,
        genre: 'Action/Adventure',
      ),
      const Movie(
        id: '3',
        title: '3 IDIOTS',
        emojiClues: ['🎓', '🎒', '🚁', '🧪'],
        releaseYear: 2009,
        genre: 'Comedy/Drama',
      ),
    ];
  }
}
