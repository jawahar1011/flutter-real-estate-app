import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'routes.dart';

class PropertyFinderApp extends StatelessWidget {
  const PropertyFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen while authentication is initializing
        if (!authProvider.isInitialized) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF000000)),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 16, color: Color(0xFF000000)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return MaterialApp.router(
          title: 'Property Finder',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF000000), // Professional black
              brightness: Brightness.light,
              primary: const Color(0xFF000000), // Professional black
              secondary: const Color(0xFF424242), // Dark grey
              surface: Colors.white,
              background: const Color(0xFFFAFAFA), // Light grey background
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: const Color(0xFF000000),
              onBackground: const Color(0xFF000000),
            ),
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(0xFF000000),
              foregroundColor: Colors.white,
            ),
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                elevation: 0,
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF000000),
                side: const BorderSide(color: Color(0xFF000000)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF000000),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.bold,
              ),
              headlineSmall: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.bold,
              ),
              titleLarge: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.w600,
              ),
              titleMedium: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.w600,
              ),
              titleSmall: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.w600,
              ),
              bodyLarge: TextStyle(color: Color(0xFF222222)),
              bodyMedium: TextStyle(color: Color(0xFF222222)),
              bodySmall: TextStyle(color: Color(0xFF717171)),
            ),
          ),
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
