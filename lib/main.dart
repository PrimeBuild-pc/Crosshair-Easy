import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'utils/logger.dart';
import 'utils/ffi_bridge.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  try {
    await Logger.initialize();
    await FFIBridge.initialize();
    
    Logger.info('Application starting');
    
    // Lock screen orientation to landscape
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // Run the app
    runApp(const CrosshairStudioApp());
  } catch (e, stackTrace) {
    print('Error during initialization: $e');
    print('Stack trace: $stackTrace');
  }
}

class CrosshairStudioApp extends StatelessWidget {
  const CrosshairStudioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crosshair Studio',
      theme: AppTheme.themeData(),
      darkTheme: AppTheme.themeData(),
      themeMode: ThemeMode.dark, // Force dark theme
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}