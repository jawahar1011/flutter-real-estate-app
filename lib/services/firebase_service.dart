import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // Temporarily disabled for web

class FirebaseService {
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  // static FirebaseStorage get storage => FirebaseStorage.instance; // Temporarily disabled for web

  static Future<void> initialize() async {
    // Configure Firestore settings
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Enable offline persistence
    await firestore.enableNetwork();
  }

  // Collection references
  static CollectionReference get usersCollection =>
      firestore.collection('users');

  static CollectionReference get listingsCollection =>
      firestore.collection('listings');

  static CollectionReference get professionalsCollection =>
      firestore.collection('professionals');

  // Helper methods for common operations
  static Future<DocumentSnapshot> getUserDoc(String userId) {
    return usersCollection.doc(userId).get();
  }

  static Future<void> createUserDoc(String userId, Map<String, dynamic> data) {
    return usersCollection.doc(userId).set(data);
  }

  static Future<void> updateUserDoc(String userId, Map<String, dynamic> data) {
    return usersCollection.doc(userId).update(data);
  }

  static Stream<QuerySnapshot> getListingsStream({
    String? category,
    String? location,
    int limit = 20,
  }) {
    Query query = listingsCollection
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    if (location != null && location.isNotEmpty) {
      query = query.where('location', isEqualTo: location);
    }

    return query.limit(limit).snapshots();
  }

  static Stream<QuerySnapshot> getProfessionalsStream({int limit = 20}) {
    return professionalsCollection
        .where('isAvailable', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(limit)
        .snapshots();
  }

  static Future<void> addListing(Map<String, dynamic> listingData) {
    return listingsCollection.add(listingData);
  }

  static Future<void> updateListing(
    String listingId,
    Map<String, dynamic> data,
  ) {
    return listingsCollection.doc(listingId).update(data);
  }

  static Future<void> deleteListing(String listingId) {
    return listingsCollection.doc(listingId).delete();
  }
}
