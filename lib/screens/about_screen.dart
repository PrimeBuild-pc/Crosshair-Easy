import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../utils/constants.dart';

/// About screen with app information
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: Center(
          child: SizedBox(
            width: 500,
            child: Card(
              margin: const EdgeInsets.all(16),
              color: AppTheme.surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.crosshairs,
                          color: AppTheme.primaryColor,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // App name
                    Text(
                      AppConstants.appName,
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // App version
                    Text(
                      'Version ${AppConstants.appVersion}',
                      style: TextStyle(
                        color: AppTheme.secondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // App description
                    Text(
                      'A powerful tool for creating, customizing, and exporting gaming crosshairs.',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Features section
                    _buildSection(
                      title: 'Features',
                      items: [
                        'Create and customize crosshairs with various shapes',
                        'Fine-tune crosshair properties like size, thickness, color',
                        'Add animations and effects',
                        'Export as PNG or SVG for use in games',
                        'Save and manage multiple crosshair profiles',
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Credits section
                    _buildSection(
                      title: 'Credits',
                      items: [
                        'Developed by Crosshair Studio Team',
                        'Built with Flutter and C++',
                        'Icon designs by Game Icons Collection',
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLinkButton(
                          icon: Icons.language,
                          label: 'Website',
                          url: 'https://crosshairstudio.example.com',
                        ),
                        const SizedBox(width: 16),
                        _buildLinkButton(
                          icon: Icons.help_outline,
                          label: 'Help',
                          url: 'https://crosshairstudio.example.com/help',
                        ),
                        const SizedBox(width: 16),
                        _buildLinkButton(
                          icon: Icons.chat_bubble_outline,
                          label: 'Feedback',
                          url: 'mailto:feedback@crosshairstudio.example.com',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Copyright
                    Text(
                      AppConstants.appCopyright,
                      style: TextStyle(
                        color: AppTheme.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Build a section with title and bullet points
  Widget _buildSection({
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildBulletPoint(item)),
      ],
    );
  }
  
  /// Build a bullet point
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build a button that links to a URL
  Widget _buildLinkButton({
    required IconData icon,
    required String label,
    required String url,
  }) {
    return OutlinedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primaryColor,
        side: BorderSide(color: AppTheme.primaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onPressed: () => _launchUrl(url),
    );
  }
  
  /// Launch a URL
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}