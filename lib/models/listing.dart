enum ListingCategory {
  realEstate,
  professionals,
  services,
}

extension ListingCategoryExtension on ListingCategory {
  String get displayName {
    switch (this) {
      case ListingCategory.realEstate:
        return 'Real Estate';
      case ListingCategory.professionals:
        return 'Professionals';
      case ListingCategory.services:
        return 'Services';
    }
  }
}

class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final ListingCategory category;
  final String location;
  final List<String> imageUrls;
  final String ownerId;
  final String ownerName;
  final String ownerEmail;
  final String? ownerPhone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isBoosted;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.location,
    this.imageUrls = const [],
    required this.ownerId,
    required this.ownerName,
    required this.ownerEmail,
    this.ownerPhone,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.isBoosted = false,
  });

  factory Listing.fromMap(Map<String, dynamic> map, String id) {
    return Listing(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: ListingCategory.values.firstWhere(
        (e) => e.toString() == 'ListingCategory.${map['category']}',
        orElse: () => ListingCategory.services,
      ),
      location: map['location'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      ownerEmail: map['ownerEmail'] ?? '',
      ownerPhone: map['ownerPhone'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
      isActive: map['isActive'] ?? true,
      isBoosted: map['isBoosted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category.toString().split('.').last,
      'location': location,
      'imageUrls': imageUrls,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isActive': isActive,
      'isBoosted': isBoosted,
    };
  }

  Listing copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    ListingCategory? category,
    String? location,
    List<String>? imageUrls,
    String? ownerId,
    String? ownerName,
    String? ownerEmail,
    String? ownerPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isBoosted,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      location: location ?? this.location,
      imageUrls: imageUrls ?? this.imageUrls,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isBoosted: isBoosted ?? this.isBoosted,
    );
  }

  String get categoryDisplayName {
    switch (category) {
      case ListingCategory.realEstate:
        return 'Real Estate';
      case ListingCategory.professionals:
        return 'Professionals';
      case ListingCategory.services:
        return 'Services';
    }
  }
}