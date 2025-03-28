import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

/// About screen of the application
class AboutScreen extends StatelessWidget {
  /// Create a new about screen
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App info
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // App logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.adjust,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // App name
                  Text(
                    Constants.appName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  // App version
                  Text(
                    'Version ${Constants.appVersion}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  // App description
                  Text(
                    Constants.appDescription,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  // Divider
                  const Divider(),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Features
            _buildSectionHeader(context, 'Features'),
            _buildFeatureItem(context, 'Create and customize crosshairs for different games'),
            _buildFeatureItem(context, 'Choose from various shapes, colors, and styles'),
            _buildFeatureItem(context, 'Organize crosshairs in game profiles'),
            _buildFeatureItem(context, 'Export crosshairs as PNG images'),
            _buildFeatureItem(context, 'Export/import profiles as CSV or JSON'),
            _buildFeatureItem(context, 'Dark mode UI'),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Developer info
            _buildSectionHeader(context, 'Developer'),
            // Company name
            _buildInfoRow(
              context,
              Icons.business,
              Constants.appAuthor,
              null,
            ),
            // Website
            _buildInfoRow(
              context,
              Icons.language,
              'Website',
              Constants.appWebsiteUrl,
              onTap: () => _launchUrl(Constants.appWebsiteUrl),
            ),
            // GitHub repository
            _buildInfoRow(
              context,
              Icons.code,
              'GitHub Repository',
              Constants.appRepositoryUrl,
              onTap: () => _launchUrl(Constants.appRepositoryUrl),
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // License
            _buildSectionHeader(context, 'License'),
            const Text(
              'This software is licensed under the MIT License. See the LICENSE file for details.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '''
MIT License

Copyright (c) 2023 ${Constants.appAuthor}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
''',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Attribution
            Center(
              child: Text(
                '© ${DateTime.now().year} ${Constants.appAuthor}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  /// Build a section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
  
  /// Build a feature item
  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build an info row
  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String? value, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: onTap != null ? AppTheme.primaryColor : null,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: onTap != null ? AppTheme.primaryColor : null,
                    ),
                  ),
                  if (value != null)
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: onTap != null ? AppTheme.primaryColor : null,
                        decoration: onTap != null ? TextDecoration.underline : null,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Launch a URL
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      await Logger.error('Failed to launch URL', e);
    }
  }
}