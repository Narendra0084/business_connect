part of 'reputation_cubit.dart';

enum ReputationStatus { initial, loaded, saved, failure }

class ReputationState extends Equatable {
  const ReputationState({
    this.status = ReputationStatus.initial,
    this.ratings = const [],
    this.message,
  });

  final ReputationStatus status;
  final List<Rating> ratings;
  final String? message;

  ReputationState copyWith({
    ReputationStatus? status,
    List<Rating>? ratings,
    String? message,
  }) {
    return ReputationState(
      status: status ?? this.status,
      ratings: ratings ?? this.ratings,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, ratings, message];
}
