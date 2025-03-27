import 'package:flutter/material.dart';

import '../models/crosshair_model.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/crosshair_preview.dart';
import '../widgets/custom_slider.dart';

class ExportScreen extends StatefulWidget {
  final CrosshairModel crosshair;

  const ExportScreen({
    Key? key,
    required this.crosshair,
  }) : super(key: key);

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  late CrosshairModel _crosshair;
  String _exportFormat = 'PNG';
  int _exportWidth = AppConstants.defaultExportWidth;
  int _exportHeight = AppConstants.defaultExportHeight;
  String _backgroundType = 'Transparent';
  bool _includeOutline = true;
  
  @override
  void initState() {
    super.initState();
    _crosshair = widget.crosshair;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Crosshair'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: Row(
          children: [
            // Left panel: Preview area
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Preview',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 400,
                          height: 400,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.dividerColor,
                              width: 1,
                            ),
                            image: _getBackgroundImage(),
                          ),
                          child: Center(
                            child: CrosshairPreview(
                              crosshair: _crosshair,
                              backgroundType: _getPreviewBackgroundType(),
                              size: 300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Export resolution: $_exportWidth x $_exportHeight',
                      style: TextStyle(
                        color: AppTheme.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Right panel: Export settings
            SizedBox(
              width: 320,
              child: Card(
                margin: const EdgeInsets.all(16),
                color: AppTheme.surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Export Settings',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Divider(color: AppTheme.dividerColor),
                      const SizedBox(height: 16),
                      
                      // Crosshair info
                      Text(
                        'Crosshair: ${_crosshair.name}',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Shape: ${_crosshair.shape}',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Export format
                      Text(
                        'Format',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFormatSelector(),
                      const SizedBox(height: 16),
                      
                      // Export size
                      Text(
                        'Size',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSizeOption(64, 64),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildSizeOption(128, 128),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildSizeOption(256, 256),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Background options
                      Text(
                        'Background',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBackgroundSelector(),
                      const SizedBox(height: 16),
                      
                      // Include outline option
                      if (_crosshair.outline) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Include Outline',
                                style: TextStyle(
                                  color: AppTheme.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Switch(
                              value: _includeOutline,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  _includeOutline = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      const Spacer(),
                      
                      // Action buttons
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Export'),
                        onPressed: () {
                          _exportCrosshair();
                        },
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy to Clipboard'),
                        onPressed: () {
                          _copyToClipboard();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build format selector
  Widget _buildFormatSelector() {
    return Row(
      children: AppConstants.supportedExportFormats.map((format) {
        final isSelected = format == _exportFormat;
        
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _exportFormat = format;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor.withOpacity(0.2)
                    : AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.dividerColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Text(
                format,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textColor,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Build a size option button
  Widget _buildSizeOption(int width, int height) {
    final isSelected = width == _exportWidth && height == _exportHeight;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _exportWidth = width;
          _exportHeight = height;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.2)
              : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          '${width}x$height',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.textColor,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Build background selector
  Widget _buildBackgroundSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildBackgroundOption('Transparent', Colors.transparent),
        _buildBackgroundOption('White', Colors.white),
        _buildBackgroundOption('Black', Colors.black),
        _buildBackgroundOption('Gray', Colors.grey.shade600),
      ],
    );
  }

  // Build a background option
  Widget _buildBackgroundOption(String name, Color color) {
    final isSelected = name == _backgroundType;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _backgroundType = name;
        });
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          image: name == 'Transparent'
              ? const DecorationImage(
                  image: AssetImage('assets/transparent_bg.png'),
                  repeat: ImageRepeat.repeat,
                )
              : null,
        ),
        child: Center(
          child: name == 'Transparent'
              ? Icon(
                  Icons.visibility_off,
                  color: AppTheme.primaryColor.withOpacity(0.7),
                  size: 20,
                )
              : null,
        ),
      ),
    );
  }

  // Get the appropriate background for the preview
  DecorationImage? _getBackgroundImage() {
    if (_backgroundType == 'Transparent') {
      // Show a checkered pattern to represent transparency
      return const DecorationImage(
        image: AssetImage('assets/transparent_bg.png'),
        repeat: ImageRepeat.repeat,
      );
    }
    return null;
  }

  // Get the background type for the preview
  String _getPreviewBackgroundType() {
    switch (_backgroundType) {
      case 'White':
        return 'White';
      case 'Black':
        return 'Dark';
      case 'Gray':
        return 'Gray';
      default:
        return 'Dark';
    }
  }

  // Export the crosshair to a file
  void _exportCrosshair() {
    // TODO: Implement actual export functionality
    
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Successful'),
        content: const Text(
          'The crosshair has been exported successfully.',
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // Copy the crosshair to clipboard
  void _copyToClipboard() {
    // TODO: Implement clipboard functionality
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        backgroundColor: AppTheme.surfaceColor,
      ),
    );
  }
}