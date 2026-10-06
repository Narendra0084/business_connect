import 'rating.dart';
import 'report.dart';

abstract class ReputationRepository {
  Future<List<Rating>> fetchRatings();

  Future<Rating> submitRating(Rating rating);

  Future<SafetyReport> submitReport(SafetyReport report);
}
