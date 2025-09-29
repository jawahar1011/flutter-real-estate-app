import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../models/professional.dart';
import '../services/listing_repository.dart';

class ListingsProvider extends ChangeNotifier {
  List<Listing> _listings = [];
  List<Professional> _professionals = [];
  List<Listing> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  ListingCategory? _selectedCategory;
  String? _selectedLocation;

  ListingsProvider() {
    // Automatically initialize data streams when provider is created
    initializeStreams();
  }

  // Getters
  List<Listing> get listings => _listings;
  List<Professional> get professionals => _professionals;
  List<Listing> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  ListingCategory? get selectedCategory => _selectedCategory;
  String? get selectedLocation => _selectedLocation;

  // Get listings by category
  List<Listing> getListingsByCategory(ListingCategory category) {
    return _listings.where((listing) => listing.category == category).toList();
  }

  // Get featured/boosted listings
  List<Listing> get featuredListings {
    return _listings.where((listing) => listing.isBoosted).toList();
  }

  // Initialize data streams
  void initializeStreams() {
    _loadListings();
    _loadProfessionals();
  }

  // Force refresh listings
  void refreshListings() {
    _loadListings();
    _loadProfessionals();
  }

  // Load listings
  void _loadListings() {
    _setLoading(true);
    
    ListingRepository.getListingsStream(
      category: _selectedCategory,
      location: _selectedLocation,
    ).listen(
      (listings) {
        _listings = listings;
        _setLoading(false);
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to load listings: $error');
        _setLoading(false);
      },
    );
  }

  // Load professionals
  void _loadProfessionals() {
    ListingRepository.getProfessionalsStream().listen(
      (professionals) {
        _professionals = professionals;
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to load professionals: $error');
      },
    );
  }

  // Search listings
  Future<void> searchListings(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _setSearching(false);
      return;
    }

    try {
      _setSearching(true);
      _clearError();
      
      final results = await ListingRepository.searchListings(query);
      _searchResults = results;
    } catch (e) {
      _setError('Search failed: $e');
    } finally {
      _setSearching(false);
    }
  }

  // Clear search results
  void clearSearch() {
    _searchResults = [];
    _setSearching(false);
  }

  // Filter by category
  void filterByCategory(ListingCategory? category) {
    _selectedCategory = category;
    _loadListings();
  }

  // Filter by location
  void filterByLocation(String? location) {
    _selectedLocation = location;
    _loadListings();
  }

  // Clear filters
  void clearFilters() {
    _selectedCategory = null;
    _selectedLocation = null;
    _loadListings();
  }

  // Add new listing
  Future<bool> addListing(Listing listing) async {
    try {
      _setLoading(true);
      _clearError();
      
      await ListingRepository.addListing(listing);
      return true;
    } catch (e) {
      _setError('Failed to add listing: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update listing
  Future<bool> updateListing(String listingId, Listing listing) async {
    try {
      _setLoading(true);
      _clearError();
      
      await ListingRepository.updateListing(listingId, listing);
      return true;
    } catch (e) {
      _setError('Failed to update listing: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete listing
  Future<bool> deleteListing(String listingId) async {
    try {
      _setLoading(true);
      _clearError();
      
      await ListingRepository.deleteListing(listingId);
      return true;
    } catch (e) {
      _setError('Failed to delete listing: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get listing by ID
  Future<Listing?> getListingById(String listingId) async {
    try {
      return await ListingRepository.getListingById(listingId);
    } catch (e) {
      _setError('Failed to get listing: $e');
      return null;
    }
  }

  // Add sample data
  Future<void> addSampleData() async {
    try {
      _setLoading(true);
      _clearError();
      
      await ListingRepository.addSampleData();
    } catch (e) {
      _setError('Failed to add sample data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSearching(bool searching) {
    _isSearching = searching;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}