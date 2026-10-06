import 'package:equatable/equatable.dart';

class SafetyReport extends Equatable {
  const SafetyReport({
    required this.id,
    required this.reportedBy,
    required this.reason,
    required this.description,
    required this.createdAt,
    this.reportedUser,
    this.reportedListing,
    this.status = ReportStatus.pending,
  });

  final String id;
  final String reportedBy;
  final String? reportedUser;
  final String? reportedListing;
  final String reason;
  final String description;
  final DateTime createdAt;
  final ReportStatus status;

  @override
  List<Object?> get props => [
        id,
        reportedBy,
        reportedUser,
        reportedListing,
        reason,
        description,
        createdAt,
        status,
      ];
}

enum ReportStatus { pending, reviewed, resolved }
