import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/rating.dart';
import '../../domain/report.dart';
import '../../domain/reputation_repository.dart';

part 'reputation_state.dart';

class ReputationCubit extends Cubit<ReputationState> {
  ReputationCubit(this._repository) : super(const ReputationState());

  final ReputationRepository _repository;

  Future<void> loadRatings() async {
    final ratings = await _repository.fetchRatings();
    emit(state.copyWith(status: ReputationStatus.loaded, ratings: ratings));
  }

  Future<void> submitRating(Rating rating) async {
    await _repository.submitRating(rating);
    final ratings = await _repository.fetchRatings();
    emit(state.copyWith(
      status: ReputationStatus.saved,
      ratings: ratings,
      message: 'Rating submitted',
    ));
  }

  Future<void> submitReport(SafetyReport report) async {
    await _repository.submitReport(report);
    emit(state.copyWith(
      status: ReputationStatus.saved,
      message: 'Report sent to admin review',
    ));
  }
}
