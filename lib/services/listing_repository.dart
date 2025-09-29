import '../models/listing.dart';
import '../models/professional.dart';
import 'firebase_service.dart';

class ListingRepository {
  // Get listings stream with optional filters
  static Stream<List<Listing>> getListingsStream({
    ListingCategory? category,
    String? location,
    int limit = 20,
  }) {
    String? categoryString = category?.toString().split('.').last;

    return FirebaseService.getListingsStream(
      category: categoryString,
      location: location,
      limit: limit,
    ).map((snapshot) {
      return snapshot.docs.map((doc) {
        return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get single listing by ID
  static Future<Listing?> getListingById(String listingId) async {
    try {
      final doc = await FirebaseService.listingsCollection.doc(listingId).get();
      if (doc.exists) {
        return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get listing: $e');
    }
  }

  // Add new listing
  static Future<String> addListing(Listing listing) async {
    try {
      final docRef = await FirebaseService.listingsCollection.add(
        listing.toMap(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add listing: $e');
    }
  }

  // Update listing
  static Future<void> updateListing(String listingId, Listing listing) async {
    try {
      await FirebaseService.updateListing(listingId, listing.toMap());
    } catch (e) {
      throw Exception('Failed to update listing: $e');
    }
  }

  // Delete listing
  static Future<void> deleteListing(String listingId) async {
    try {
      await FirebaseService.deleteListing(listingId);
    } catch (e) {
      throw Exception('Failed to delete listing: $e');
    }
  }

  // Get user's listings
  static Stream<List<Listing>> getUserListingsStream(String userId) {
    return FirebaseService.listingsCollection
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  // Search listings
  static Future<List<Listing>> searchListings(String query) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a basic implementation that searches in title and description
      final snapshot = await FirebaseService.listingsCollection
          .where('isActive', isEqualTo: true)
          .get();

      final listings = snapshot.docs.map((doc) {
        return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Filter results based on query
      final filteredListings = listings.where((listing) {
        final searchQuery = query.toLowerCase();
        return listing.title.toLowerCase().contains(searchQuery) ||
            listing.description.toLowerCase().contains(searchQuery) ||
            listing.location.toLowerCase().contains(searchQuery);
      }).toList();

      return filteredListings;
    } catch (e) {
      throw Exception('Failed to search listings: $e');
    }
  }

  // Get professionals stream
  static Stream<List<Professional>> getProfessionalsStream({int limit = 20}) {
    return FirebaseService.getProfessionalsStream(limit: limit).map((snapshot) {
      return snapshot.docs.map((doc) {
        return Professional.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Add sample data for testing
  static Future<void> addSampleData() async {
    try {
      // Sample listings
      final sampleListings = [
        Listing(
          id: '',
          title: 'Beautiful 3BHK Apartment',
          description:
              'Spacious 3BHK apartment with modern amenities, parking, and great location.',
          price: 25000,
          category: ListingCategory.realEstate,
          location: 'Mumbai',
          imageUrls: [
            'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500',
            'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
          ],
          ownerId: 'sample_user',
          ownerName: 'John Doe',
          ownerEmail: 'john@example.com',
          ownerPhone: '+91 9876543210',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Listing(
          id: '',
          title: 'Home Cleaning Service',
          description:
              'Professional home cleaning service with experienced staff.',
          price: 500,
          category: ListingCategory.services,
          location: 'Delhi',
          imageUrls: [
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500',
          ],
          ownerId: 'sample_user',
          ownerName: 'Jane Smith',
          ownerEmail: 'jane@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (final listing in sampleListings) {
        await addListing(listing);
      }

      // Sample professionals
      final sampleProfessionals = [
        Professional(
          id: '',
          name: 'Dr. Sarah Wilson',
          profession: 'Dentist',
          description: 'Experienced dentist with 10+ years of practice.',
          email: 'sarah@example.com',
          phone: '+91 9876543211',
          skills: ['General Dentistry', 'Cosmetic Dentistry', 'Root Canal'],
          rating: 4.8,
          reviewCount: 156,
          location: 'Mumbai',
          hourlyRate: 1500,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Professional(
          id: '',
          name: 'Mike Johnson',
          profession: 'Plumber',
          description: 'Reliable plumber for all your plumbing needs.',
          email: 'mike@example.com',
          phone: '+91 9876543212',
          skills: ['Pipe Repair', 'Installation', 'Emergency Service'],
          rating: 4.5,
          reviewCount: 89,
          location: 'Delhi',
          hourlyRate: 800,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (final professional in sampleProfessionals) {
        await FirebaseService.professionalsCollection.add(professional.toMap());
      }
    } catch (e) {
      throw Exception('Failed to add sample data: $e');
    }
  }
}
