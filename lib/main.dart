import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/services/cache_service.dart';
import 'core/services/storage_service.dart';
import 'core/di/dependency_injection.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (must be before any Firebase service usage)
  await Firebase.initializeApp();

  // Initialize cache service
  await CacheService().init();

  // Initialize and register StorageService as a singleton
  final storageService = StorageService();
  await storageService.init();
  Get.put<StorageService>(storageService, permanent: true);

  // Pre-cache Open Sans font - downloads once and caches for offline use
  GoogleFonts.config.allowRuntimeFetching = true;

  // Pre-load Open Sans font to cache it on first run
  try {
    await Future.wait([
      GoogleFonts.pendingFonts([GoogleFonts.openSans()]),
    ]);
  } catch (e) {
    // If offline or font loading fails, app will use fallback fonts
    debugPrint('Font pre-caching failed: $e');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

