import '../domain/rating.dart';
import '../domain/report.dart';
import '../domain/reputation_repository.dart';

class InMemoryReputationRepository implements ReputationRepository {
  final List<Rating> _ratings = [
    Rating(
      id: 'rating-1',
      orderId: 'order-1',
      fromUserId: 'buyer-1',
      toUserId: 'seller-1',
      stars: 5,
      comment: 'Clear communication and strong packing.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  final List<SafetyReport> _reports = [];

  @override
  Future<List<Rating>> fetchRatings() async {
    return List.unmodifiable(_ratings);
  }

  @override
  Future<Rating> submitRating(Rating rating) async {
    _ratings.insert(0, rating);
    return rating;
  }

  @override
  Future<SafetyReport> submitReport(SafetyReport report) async {
    _reports.insert(0, report);
    return report;
  }
}
