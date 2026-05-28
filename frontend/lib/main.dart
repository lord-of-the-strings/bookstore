import 'package:bookstore/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/phone_screen.dart';
import 'providers/auth_provider.dart';
import 'package:bookstore/core/api_client.dart';
import 'dart:io';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!Platform.isLinux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  ApiClient.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState=ref.watch(authStateProvider);
    return MaterialApp(
      title: 'The Book Nook',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: ThemeMode.system,
      home: authState.when(
        data: (user)=>user!=null
            ? const HomeScreen()
            : const PhoneScreen(),
        loading: ()=>const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      error: (_,__)=> const PhoneScreen(),
      ),
    );
  }
}

ThemeData _lightTheme() {
  const primary = Color(0xFF6B3F1F);      // rich walnut brown
  const secondary = Color(0xFFD4956A);    // warm tan
  const background = Color(0xFFFDF6EC);   // aged paper cream
  const surface = Color(0xFFFFF8F0);      // warm white
  const onPrimary = Color(0xFFFFF8F0);

  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: background,
      surface: surface,
      onPrimary: onPrimary,
      onSecondary: Colors.white,
      onBackground: Color(0xFF2C1A0E),
      onSurface: Color(0xFF2C1A0E),
      primaryContainer: Color(0xFFEDD9C0),
      onPrimaryContainer: primary,
      surfaceVariant: Color(0xFFEDE0D4),
    ),
    scaffoldBackgroundColor: background,
    fontFamily: 'Georgia',
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: onPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 2,
      shadowColor: primary.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFEDE0D4),
      selectedColor: primary,
      labelStyle: const TextStyle(fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

ThemeData _darkTheme() {
  const primary = Color(0xFFD4956A);      // warm tan as primary in dark
  const secondary = Color(0xFF6B3F1F);
  const background = Color(0xFF1A110A);   // deep espresso
  const surface = Color(0xFF2C1E14);      // dark walnut
  const onPrimary = Color(0xFF1A110A);

  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      onPrimary: onPrimary,
      onSecondary: Colors.white,
      onSurface: Color(0xFFFDF6EC),
      primaryContainer: Color(0xFF4A2810),
      onPrimaryContainer: Color(0xFFEDD9C0),
      surfaceContainerHighest: Color(0xFF3D2515),
    ),
    scaffoldBackgroundColor: background,
    fontFamily: 'Georgia',
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: Color(0xFFFDF6EC),
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 2,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF3D2515),
      selectedColor: primary,
      labelStyle: const TextStyle(fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
