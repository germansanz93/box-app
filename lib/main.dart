import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:box_app/providers/branding_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase already initialized: $e');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BrandingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandingProvider>(
      builder: (context, brandingProvider, child) {
        return MaterialApp(
          title: brandingProvider.branding.boxName,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: brandingProvider.primaryColor,
              primary: brandingProvider.primaryColor,
              secondary: brandingProvider.secondaryColor,
              // Make sure the surface and backgrounds harmonize or contrast well
              surface: Colors.grey[50], 
            ),
            
            // App Bar Theme
            appBarTheme: AppBarTheme(
              backgroundColor: brandingProvider.primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              centerTitle: true,
            ),

            // Elevated Button Theme - make them pop with primary color
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandingProvider.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),

            // Text Button Theme
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: brandingProvider.primaryColor,
              ),
            ),

            // Floating Action Button Theme
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: brandingProvider.secondaryColor,
              foregroundColor: Colors.black, // Or contrasting text color
            ),

            // Input Decoration Theme - Outline borders with primary color
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: brandingProvider.primaryColor, width: 2),
              ),
              labelStyle: TextStyle(color: Colors.grey[700]),
              floatingLabelStyle: TextStyle(color: brandingProvider.primaryColor),
            ),

            // Card Theme
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.all(8),
              color: Colors.white,
              shadowColor: brandingProvider.primaryColor.withOpacity(0.2),
            ),
          ),
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          }
          return HomeScreen();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
