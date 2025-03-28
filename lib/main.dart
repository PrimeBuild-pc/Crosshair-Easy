import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/home_screen.dart';
import 'services/crosshair_service.dart';
import 'services/profile_service.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';
import 'utils/ffi_bridge.dart';
import 'utils/logger.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize the FFI bridge
    await FFIBridge.initialize();
    
    // Initialize the window manager
    await windowManager.ensureInitialized();
    
    // Configure the window
    WindowOptions windowOptions = WindowOptions(
      size: const Size(
        Constants.windowDefaultWidth,
        Constants.windowDefaultHeight,
      ),
      minimumSize: const Size(
        Constants.windowMinWidth,
        Constants.windowMinHeight,
      ),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      title: Constants.windowTitle,
    );
    
    // Apply the window configuration
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    
    await Logger.info('Application started');
  } catch (e) {
    await Logger.error('Failed to initialize application', e);
  }
  
  // Run the application
  runApp(const CrosshairStudio());
}

/// The main application widget
class CrosshairStudio extends StatefulWidget {
  /// Create a new CrosshairStudio application
  const CrosshairStudio({Key? key}) : super(key: key);

  @override
  State<CrosshairStudio> createState() => _CrosshairStudioState();
}

class _CrosshairStudioState extends State<CrosshairStudio> {
  final CrosshairService _crosshairService = CrosshairService();
  final ProfileService _profileService = ProfileService();
  bool _initialized = false;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }
  
  Future<void> _initializeServices() async {
    try {
      // Initialize services
      await _crosshairService.initialize();
      await _profileService.initialize();
      
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e) {
      await Logger.error('Failed to initialize services', e);
      
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        title: Constants.appName,
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize application',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _error = null;
                      _initialized = false;
                    });
                    _initializeServices();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    if (!_initialized) {
      return MaterialApp(
        title: Constants.appName,
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Initializing ${Constants.appName}...',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _crosshairService),
        ChangeNotifierProvider.value(value: _profileService),
      ],
      child: MaterialApp(
        title: Constants.appName,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}