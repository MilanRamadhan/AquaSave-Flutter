class IoTTool {
  final String id;
  final String userId;
  final String toolName;
  final double totalUsedWater;

  IoTTool({
    required this.id,
    required this.userId,
    required this.toolName,
    required this.totalUsedWater,
  });

  // Factory method untuk membuat instance dari JSON
  factory IoTTool.fromJson(Map<String, dynamic> json) {
    return IoTTool(
      id: json['_id'] ?? '', // Sesuaikan dengan field dari backend
      userId: json['userId'] ?? '',
      toolName: json['toolName'] ?? '',
      totalUsedWater: (json['totalUsedWater'] ?? 0).toDouble(),
    );
  }

  // Method untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'toolName': toolName,
      'totalUsedWater': totalUsedWater,
    };
  }
}