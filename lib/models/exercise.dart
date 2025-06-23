class Exercise {
  final int id;
  final String title;
  final String instructionNl;
  final String instructionEn;

  Exercise({
    required this.id,
    required this.title,
    required this.instructionNl,
    required this.instructionEn,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      title: json['title'] ?? '',
      instructionNl: json['instruction_nl'] ?? '',
      instructionEn: json['instruction_en'] ?? '',
    );
  }
}
