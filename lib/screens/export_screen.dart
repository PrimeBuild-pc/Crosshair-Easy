import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/crosshair_model.dart';
import '../services/crosshair_service.dart';
import '../services/export_service.dart';
import '../services/profile_service.dart';
import '../theme/app_theme.dart';
import '../widgets/crosshair_preview.dart';

/// Screen for exporting crosshairs
class ExportScreen extends StatefulWidget {
  /// The crosshair to export
  final CrosshairModel crosshair;
  
  /// Create a new export screen
  const ExportScreen({
    Key? key,
    required this.crosshair,
  }) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  int _exportSize = 128;
  bool _showDarkBackground = true;
  bool _showLightBackground = false;
  bool _showTransparentBackground = false;
  bool _isExporting = false;
  String? _errorMessage;
  String? _successMessage;
  
  Future<void> _exportAsPng() async {
    setState(() {
      _isExporting = true;
      _errorMessage = null;
      _successMessage = null;
    });
    
    try {
      final crosshairService = Provider.of<CrosshairService>(context, listen: false);
      
      final imageData = await crosshairService.renderCrosshair(
        widget.crosshair,
        width: _exportSize,
        height: _exportSize,
      );
      
      final fileName = await ExportService.exportCrosshairAsPng(
        imageData,
        '${widget.crosshair.name}_${_exportSize}x${_exportSize}',
      );
      
      setState(() {
        _successMessage = 'Crosshair exported successfully: $fileName';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to export crosshair: $e';
      });
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }
  
  Future<void> _exportProfileAsCsv() async {
    setState(() {
      _isExporting = true;
      _errorMessage = null;
      _successMessage = null;
    });
    
    try {
      final profileService = Provider.of<ProfileService>(context, listen: false);
      final profile = profileService.selectedProfile;
      
      if (profile == null) {
        throw 'No profile selected';
      }
      
      final fileName = await ExportService.exportProfileAsCsv(profile);
      
      setState(() {
        _successMessage = 'Profile exported as CSV: $fileName';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to export profile: $e';
      });
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }
  
  Future<void> _exportProfileAsJson() async {
    setState(() {
      _isExporting = true;
      _errorMessage = null;
      _successMessage = null;
    });
    
    try {
      final profileService = Provider.of<ProfileService>(context, listen: false);
      final profile = profileService.selectedProfile;
      
      if (profile == null) {
        throw 'No profile selected';
      }
      
      final fileName = await ExportService.exportProfileAsJson(profile);
      
      setState(() {
        _successMessage = 'Profile exported as JSON: $fileName';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to export profile: $e';
      });
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }
  
  void _toggleBackgroundType(String type) {
    setState(() {
      switch (type) {
        case 'dark':
          _showDarkBackground = true;
          _showLightBackground = false;
          _showTransparentBackground = false;
          break;
        case 'light':
          _showDarkBackground = false;
          _showLightBackground = true;
          _showTransparentBackground = false;
          break;
        case 'transparent':
          _showDarkBackground = false;
          _showLightBackground = false;
          _showTransparentBackground = true;
          break;
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final crosshairService = Provider.of<CrosshairService>(context);
    final profileService = Provider.of<ProfileService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Crosshair'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left panel: Crosshair preview
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        'Preview',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      CrosshairPreview(
                        crosshair: widget.crosshair,
                        crosshairService: crosshairService,
                        width: 300,
                        height: 300,
                        showDarkBackground: _showDarkBackground,
                        showLightBackground: _showLightBackground,
                        showTransparentBackground: _showTransparentBackground,
                      ),
                      const SizedBox(height: 16),
                      // Background selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBackgroundSelector(
                            'Dark',
                            _showDarkBackground,
                            () => _toggleBackgroundType('dark'),
                            Colors.black,
                          ),
                          const SizedBox(width: 16),
                          _buildBackgroundSelector(
                            'Light',
                            _showLightBackground,
                            () => _toggleBackgroundType('light'),
                            Colors.white,
                          ),
                          const SizedBox(width: 16),
                          _buildBackgroundSelector(
                            'Transparent',
                            _showTransparentBackground,
                            () => _toggleBackgroundType('transparent'),
                            null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 32),
                
                // Right panel: Export options
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Export Options',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      // Image size selector
                      Text(
                        'Image Size',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [32, 64, 128, 256, 512].map((size) {
                          final isSelected = _exportSize == size;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _exportSize = size;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.surfaceColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.grey,
                                ),
                              ),
                              child: Text(
                                '${size}px',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      // Export buttons
                      Text(
                        'Export Format',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      // Crosshair as PNG
                      ElevatedButton.icon(
                        onPressed: _isExporting ? null : _exportAsPng,
                        icon: const Icon(Icons.image),
                        label: const Text('Export Crosshair as PNG'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Profile as CSV
                      ElevatedButton.icon(
                        onPressed: _isExporting ? null : _exportProfileAsCsv,
                        icon: const Icon(Icons.table_chart),
                        label: const Text('Export ${profileService.selectedProfile?.name ?? 'Profile'} as CSV'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Profile as JSON
                      ElevatedButton.icon(
                        onPressed: _isExporting ? null : _exportProfileAsJson,
                        icon: const Icon(Icons.code),
                        label: const Text('Export ${profileService.selectedProfile?.name ?? 'Profile'} as JSON'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_isExporting)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_successMessage != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _successMessage!,
                                  style: const TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBackgroundSelector(
    String label,
    bool isSelected,
    VoidCallback onTap,
    Color? color,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(4),
                image: color == null
                    ? const DecorationImage(
                        image: AssetImage('assets/transparent_bg.svg'),
                        repeat: ImageRepeat.repeat,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.primaryColor
                    : null,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}