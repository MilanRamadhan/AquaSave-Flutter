class WaterUsage {
  final DateTime date;
  final double usage;
  final String status;

  WaterUsage({
    required this.date,
    required this.usage,
    required this.status,
  });

  factory WaterUsage.fromJson(Map<String, dynamic> json) {
    return WaterUsage(
      date: DateTime.parse(json['date']),
      usage: (json['usage'] as num).toDouble(),
      status: json['status'] ?? 'Normal',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'usage': usage,
      'status': status,
    };
  }
}
