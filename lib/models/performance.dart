import 'exercise.dart';

class Performance {
  final int id;
  final int userId;
  final int exerciseId;
  final String result;
  final DateTime? createdAt;
  final Exercise? exercise;

  Performance({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.result,
    this.createdAt,
    this.exercise,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      id: json['id'],
      userId: json['user_id'],
      exerciseId: json['exercise_id'],
      result: json['result'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      exercise: json['exercise'] != null ? Exercise.fromJson(json['exercise']) : null,
    );
  }
}
