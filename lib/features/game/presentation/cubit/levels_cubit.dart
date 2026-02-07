import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/level_repository.dart';
import 'levels_state.dart';

class LevelsCubit extends Cubit<LevelsState> {
  final LevelRepository _repository;

  LevelsCubit(this._repository) : super(const LevelsState());

  Future<void> fetchProgress() async {
    emit(state.copyWith(status: LevelsStatus.loading));
    try {
      final progress = await _repository.getAllProgress();
      // We don't have a direct "getAllLevels" yet, so let's get a count
      // by loading level 1 and checking how many we have in total
      // Or just hardcode 14 for now based on the UI design.
      // Actually, let's load level 1 to trigger the load and parse.
      await _repository.getLevel(1);

      emit(
        state.copyWith(
          status: LevelsStatus.loaded,
          progress: progress,
          totalLevels: 14, // Hardcoded for this map design
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: LevelsStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
