import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

/// The about screen
class AboutScreen extends StatelessWidget {
  /// Create a new about screen
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.backgroundGradientStart,
              AppTheme.backgroundGradientEnd,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App logo
              const SizedBox(height: Constants.padding * 2),
              const Icon(
                Icons.sports_esports,
                size: 100,
                color: AppTheme.primary,
              ),
              
              // App name and version
              const SizedBox(height: Constants.padding),
              const Text(
                'Crosshair Designer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Constants.paddingSmall),
              const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              // Description
              const SizedBox(height: Constants.padding * 2),
              const Text(
                'A desktop application for creating, customizing, and exporting gaming crosshairs',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              // Divider
              const SizedBox(height: Constants.padding * 2),
              const Divider(),
              const SizedBox(height: Constants.padding),
              
              // Features
              const Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: Constants.padding),
              _buildFeature(
                icon: Icons.brush,
                title: 'Customizable',
                description: 'Create and customize crosshairs with various shapes, colors, sizes, and more',
              ),
              _buildFeature(
                icon: Icons.save,
                title: 'Profiles',
                description: 'Save and organize crosshairs in profiles for different games',
              ),
              _buildFeature(
                icon: Icons.import_export,
                title: 'Export',
                description: 'Export crosshair settings as CSV files for sharing or backup',
              ),
              _buildFeature(
                icon: Icons.speed,
                title: 'Performance',
                description: 'Built with Flutter UI and C++ backend for optimal performance',
              ),
              
              // Divider
              const SizedBox(height: Constants.padding),
              const Divider(),
              const SizedBox(height: Constants.padding),
              
              // Credits
              const Text(
                'Credits',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: Constants.padding),
              const Text(
                'Created by Your Name',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Constants.paddingSmall),
              Text.rich(
                TextSpan(
                  text: 'Visit ',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: 'our website',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = Uri.parse('https://example.com');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                    ),
                    const TextSpan(
                      text: ' for more information',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              
              // License
              const SizedBox(height: Constants.padding * 2),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding),
                  child: Column(
                    children: [
                      Text(
                        'License',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: Constants.paddingSmall),
                      Text(
                        'This software is licensed under the MIT License. See the LICENSE file for details.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Copyright
              const SizedBox(height: Constants.padding * 2),
              Text(
                '© ${DateTime.now().year} Your Company. All rights reserved.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Constants.padding * 2),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build a feature item
  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Constants.padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.paddingSmall),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: Constants.padding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: Constants.paddingSmall / 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}