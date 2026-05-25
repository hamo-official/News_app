class UserProfileModel {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final DateTime? updatedAt;

  const UserProfileModel({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'updated_at': updatedAt?.toIso8601String(),
      };

  UserProfileModel copyWith({String? fullName, String? avatarUrl}) {
    return UserProfileModel(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      updatedAt: DateTime.now(),
    );
  }
}
