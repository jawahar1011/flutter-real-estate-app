import 'package:go_router/go_router.dart';
import 'package:property_finder_app/ui/screens/admin/admin_panel_screen.dart';
import 'package:property_finder_app/ui/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'ui/screens/add_listing/add_listing_screen.dart';
import 'ui/screens/admin/data_init_screen.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/home/listing_detail.dart';
import 'ui/screens/professionals/professionals_screen.dart';
import 'ui/screens/wishlist/wishlist_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = authProvider.isAuthenticated;
      final isGuest = authProvider.isGuest;
      final isInitialized = authProvider.isInitialized;

      // Don't redirect if authentication is still initializing
      if (!isInitialized) {
        return null;
      }

      // If user is on login page and already authenticated, redirect to home
      if (state.uri.path == '/login' && (isLoggedIn || isGuest)) {
        return '/home';
      }

      // If user is not authenticated and not on login page, redirect to login
      if (!isLoggedIn && !isGuest && state.uri.path != '/login') {
        return '/login';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/listing/:id',
        name: 'listing-detail',
        builder: (context, state) {
          final listingId = state.pathParameters['id']!;
          return ListingDetailScreen(listingId: listingId);
        },
      ),
      GoRoute(
        path: '/add-listing',
        name: 'add-listing',
        builder: (context, state) => const AddListingScreen(),
      ),
      GoRoute(
        path: '/professionals',
        name: 'professionals',
        builder: (context, state) => const ProfessionalsScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        name: 'wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminPanelScreen(),
      ),
      GoRoute(
        path: '/admin/init-data',
        name: 'init-data',
        builder: (context, state) => const DataInitScreen(),
      ),
    ],
  );
}
