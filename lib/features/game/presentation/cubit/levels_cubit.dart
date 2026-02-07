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
      
      
      
      
      await _repository.getLevel(1);

      emit(
        state.copyWith(
          status: LevelsStatus.loaded,
          progress: progress,
          totalLevels: 14, 
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: LevelsStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
