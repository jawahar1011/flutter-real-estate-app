import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/listing.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/listings_provider.dart';
import '../../widgets/animated_search.dart';
import '../../widgets/top_bar_buttons.dart';
import 'listing_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _showSearchResults = false;
  ListingCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // Initialize listings data after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      final listingsProvider = Provider.of<ListingsProvider>(
        context,
        listen: false,
      );
      listingsProvider.initializeStreams();

      // Force refresh if no listings are loaded
      if (listingsProvider.listings.isEmpty) {
        listingsProvider.refreshListings();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildSearchSection(),
                    _buildQuickAccessButtons(),
                    _buildFeaturedSection(),
                    _buildCategorySections(),
                    const SizedBox(height: 80), // Bottom padding for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SliverAppBar(
          expandedHeight: 120,
          floating: true,
          pinned: true,
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Property Finder',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            if (authProvider.isGuest)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.favorite_outline, color: Colors.white),
              onPressed: () => context.push('/wishlist'),
              tooltip: 'Wishlist',
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                switch (value) {
                  case 'profile':
                    context.push('/profile');
                    break;
                  case 'admin':
                    context.push('/admin');
                    break;
                  case 'settings':
                    // TODO: Navigate to settings
                    break;
                  case 'logout':
                    _handleLogout();
                    break;
                }
              },
              itemBuilder: (context) => [
                if (!authProvider.isGuest) ...[
                  const PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('Profile'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
                if (authProvider.isAdmin) ...[
                  const PopupMenuItem(
                    value: 'admin',
                    child: ListTile(
                      leading: Icon(Icons.admin_panel_settings),
                      title: Text('Admin Panel'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
                const PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text('Settings'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: Text(authProvider.isGuest ? 'Sign In' : 'Logout'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: AnimatedSearch(
        controller: _searchController,
        onChanged: _handleSearch,
        onSubmitted: _handleSearchSubmit,
        onClear: _handleSearchClear,
      ),
    );
  }

  Widget _buildQuickAccessButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TopBarButtons(
        onCategorySelected: _handleCategorySelection,
        selectedCategory: _selectedCategory,
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Consumer<ListingsProvider>(
      builder: (context, listingsProvider, child) {
        final featuredListings = listingsProvider.featuredListings;

        // Show loading state for featured section
        if (listingsProvider.isLoading && featuredListings.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.star, color: Colors.amber, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading featured listings...',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ),
          );
        }

        if (featuredListings.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Featured Listings',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 420, // Optimized height for better card proportions
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: featuredListings.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300, // Increased width for better proportions
                      margin: const EdgeInsets.only(right: 16),
                      child: ListingCard(
                        listing: featuredListings[index],
                        onTap: () =>
                            _navigateToListing(featuredListings[index]),
                        isFeatured: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySections() {
    return Consumer<ListingsProvider>(
      builder: (context, listingsProvider, child) {
        if (_showSearchResults) {
          return _buildSearchResults();
        }

        if (_selectedCategory != null) {
          return _buildCategoryListings(_selectedCategory!);
        }

        // Show loading state if listings are being loaded
        if (listingsProvider.isLoading && listingsProvider.listings.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading listings...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        // Show empty state if no listings are available
        if (!listingsProvider.isLoading && listingsProvider.listings.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.home_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 24),
                  Text(
                    'No listings available',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Check back later for new listings',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      listingsProvider.refreshListings();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            _buildCategorySection(ListingCategory.realEstate),
            _buildCategorySection(ListingCategory.professionals),
            _buildCategorySection(ListingCategory.services),
          ],
        );
      },
    );
  }

  Widget _buildCategorySection(ListingCategory category) {
    return Consumer<ListingsProvider>(
      builder: (context, listingsProvider, child) {
        final categoryListings = listingsProvider.getListingsByCategory(
          category,
        );

        if (categoryListings.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(top: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(category),
                            color: _getCategoryColor(category),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          category.displayName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[800],
                              ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () => _handleCategorySelection(category),
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      label: const Text('View All'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 420, // Optimized height for better card proportions
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categoryListings.take(10).length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300, // Increased width for better proportions
                      margin: const EdgeInsets.only(right: 16),
                      child: ListingCard(
                        listing: categoryListings[index],
                        onTap: () =>
                            _navigateToListing(categoryListings[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryListings(ListingCategory category) {
    return Consumer<ListingsProvider>(
      builder: (context, listingsProvider, child) {
        final categoryListings = listingsProvider.getListingsByCategory(
          category,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                      // Clear category filter in provider
                      Provider.of<ListingsProvider>(
                        context,
                        listen: false,
                      ).clearFilters();
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(category),
                            color: _getCategoryColor(category),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          category.displayName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[800],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (categoryListings.isEmpty)
              _buildEmptyState('No listings found in ${category.displayName}')
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStaggeredGrid(categoryListings),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Consumer<ListingsProvider>(
      builder: (context, listingsProvider, child) {
        if (listingsProvider.isSearching) {
          return Container(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Searching...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        final searchResults = listingsProvider.searchResults;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: _handleSearchClear,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search Results (${searchResults.length})',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (searchResults.isEmpty)
              _buildEmptyState(
                'No results found for "${_searchController.text}"',
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStaggeredGrid(searchResults),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStaggeredGrid(List<Listing> listings) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on screen width
        int crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
        double itemWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: listings.map((listing) {
            return SizedBox(
              height: 420, // Updated to match home screen card proportions
              width: itemWidth,
              child: ListingCard(
                listing: listing,
                onTap: () => _navigateToListing(listing),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Try adjusting your search or browse categories',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return FloatingActionButton.extended(
          onPressed: () {
            if (authProvider.isGuest) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Please sign in to add listings'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  action: SnackBarAction(
                    label: 'Sign In',
                    textColor: Colors.white,
                    onPressed: () => context.push('/login'),
                  ),
                ),
              );
            } else {
              context.push('/add-listing');
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Listing'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        );
      },
    );
  }

  // Helper methods for category styling
  IconData _getCategoryIcon(ListingCategory category) {
    switch (category) {
      case ListingCategory.realEstate:
        return Icons.home_outlined;
      case ListingCategory.professionals:
        return Icons.work_outline;
      case ListingCategory.services:
        return Icons.build_outlined;
    }
  }

  Color _getCategoryColor(ListingCategory category) {
    switch (category) {
      case ListingCategory.realEstate:
        return const Color(0xFFE31C5F); // Airbnb red
      case ListingCategory.professionals:
        return const Color(0xFF222222); // Airbnb black
      case ListingCategory.services:
        return const Color(0xFF717171); // Airbnb gray
    }
  }

  // Event handlers
  void _handleSearch(String query) {
    if (query.trim().isEmpty) {
      _handleSearchClear();
      return;
    }

    Provider.of<ListingsProvider>(context, listen: false).searchListings(query);
    setState(() {
      _showSearchResults = true;
    });
  }

  void _handleSearchSubmit(String query) {
    _handleSearch(query);
  }

  void _handleSearchClear() {
    _searchController.clear();
    Provider.of<ListingsProvider>(context, listen: false).clearSearch();
    setState(() {
      _showSearchResults = false;
    });
  }

  void _handleCategorySelection(ListingCategory category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? null : category;
      _showSearchResults = false;
    });
    _searchController.clear();

    // Update listings provider with category filter
    Provider.of<ListingsProvider>(
      context,
      listen: false,
    ).filterByCategory(_selectedCategory);
  }

  void _navigateToListing(Listing listing) {
    context.push('/listing/${listing.id}');
  }

  void _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isGuest) {
      context.go('/login');
    } else {
      await authProvider.signOut();
      if (mounted) {
        context.go('/login');
      }
    }
  }
}
