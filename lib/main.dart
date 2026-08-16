import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF111633),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const LinkShieldApp());
}

class LinkShieldApp extends StatelessWidget {
  const LinkShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkShield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00D4FF),
          secondary: const Color(0xFF00FF88),
          surface: const Color(0xFF141832),
          error: const Color(0xFFFF3366),
          onPrimary: const Color(0xFF0A0E27),
          onSurface: Colors.white,
          outline: Colors.white.withValues(alpha: 0.1),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0A0E27),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D4FF),
            foregroundColor: const Color(0xFF0A0E27),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF141832),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          hintStyle: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
