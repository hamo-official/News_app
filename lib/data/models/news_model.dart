class NewsModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final DateTime createdAt;
  final String? category;

  const NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.createdAt,
    this.category,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image': image,
        'created_at': createdAt.toIso8601String(),
        'category': category,
      };
}
