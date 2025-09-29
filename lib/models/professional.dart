class Professional {
  final String id;
  final String name;
  final String profession;
  final String description;
  final String email;
  final String? phone;
  final String? profileImageUrl;
  final List<String> skills;
  final double rating;
  final int reviewCount;
  final String location;
  final double hourlyRate;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  Professional({
    required this.id,
    required this.name,
    required this.profession,
    required this.description,
    required this.email,
    this.phone,
    this.profileImageUrl,
    this.skills = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.location,
    this.hourlyRate = 0.0,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Professional.fromMap(Map<String, dynamic> map, String id) {
    return Professional(
      id: id,
      name: map['name'] ?? '',
      profession: map['profession'] ?? '',
      description: map['description'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      profileImageUrl: map['profileImageUrl'],
      skills: List<String>.from(map['skills'] ?? []),
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      location: map['location'] ?? '',
      hourlyRate: (map['hourlyRate'] ?? 0.0).toDouble(),
      isAvailable: map['isAvailable'] ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profession': profession,
      'description': description,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'skills': skills,
      'rating': rating,
      'reviewCount': reviewCount,
      'location': location,
      'hourlyRate': hourlyRate,
      'isAvailable': isAvailable,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Professional copyWith({
    String? id,
    String? name,
    String? profession,
    String? description,
    String? email,
    String? phone,
    String? profileImageUrl,
    List<String>? skills,
    double? rating,
    int? reviewCount,
    String? location,
    double? hourlyRate,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Professional(
      id: id ?? this.id,
      name: name ?? this.name,
      profession: profession ?? this.profession,
      description: description ?? this.description,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      skills: skills ?? this.skills,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      location: location ?? this.location,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}