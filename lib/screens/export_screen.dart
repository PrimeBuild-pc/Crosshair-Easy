import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import '../services/crosshair_service.dart';
import '../services/export_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/crosshair_preview.dart';

/// The export screen
class ExportScreen extends StatefulWidget {
  /// Create a new export screen
  const ExportScreen({Key? key}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  /// The selected profile
  ProfileModel? _selectedProfile;
  
  /// Whether all profiles are selected
  bool _allProfilesSelected = false;
  
  /// The export format
  String _exportFormat = 'CSV';
  
  /// Whether the export is in progress
  bool _exporting = false;
  
  /// The export result message
  String? _exportResult;
  
  /// Whether the export was successful
  bool _exportSuccess = false;
  
  @override
  void initState() {
    super.initState();
    
    // Load the active profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActiveProfile();
    });
  }
  
  /// Load the active profile
  void _loadActiveProfile() {
    final profileService = Provider.of<ProfileService>(context, listen: false);
    
    setState(() {
      _selectedProfile = profileService.activeProfile;
    });
  }
  
  /// Set the selected profile
  void _setSelectedProfile(ProfileModel? profile) {
    setState(() {
      _selectedProfile = profile;
      _allProfilesSelected = false;
      _exportResult = null;
    });
  }
  
  /// Set all profiles selected
  void _setAllProfilesSelected(bool selected) {
    setState(() {
      _allProfilesSelected = selected;
      if (selected) {
        _selectedProfile = null;
      } else {
        _loadActiveProfile();
      }
      _exportResult = null;
    });
  }
  
  /// Set the export format
  void _setExportFormat(String format) {
    setState(() {
      _exportFormat = format;
      _exportResult = null;
    });
  }
  
  /// Export the selected profile or all profiles
  Future<void> _export() async {
    if (_allProfilesSelected == false && _selectedProfile == null) {
      _showError('Please select a profile or all profiles.');
      return;
    }
    
    final profileService = Provider.of<ProfileService>(context, listen: false);
    final crosshairService = Provider.of<CrosshairService>(context, listen: false);
    
    setState(() {
      _exporting = true;
      _exportResult = null;
    });
    
    try {
      String filePath;
      
      if (_allProfilesSelected) {
        filePath = await ExportService.exportAllProfilesAsCsv(
          profileService.profiles,
          crosshairService.crosshairs,
        );
        
        setState(() {
          _exportResult = 'All profiles exported to $filePath';
          _exportSuccess = true;
        });
      } else if (_selectedProfile != null) {
        filePath = await ExportService.exportProfileAsCsv(
          _selectedProfile!,
          crosshairService.crosshairs,
        );
        
        setState(() {
          _exportResult = 'Profile "${_selectedProfile!.name}" exported to $filePath';
          _exportSuccess = true;
        });
      }
    } catch (e) {
      _showError('Export failed: $e');
    } finally {
      setState(() {
        _exporting = false;
      });
    }
  }
  
  /// Copy to clipboard
  Future<void> _copyToClipboard() async {
    if (_allProfilesSelected == false && _selectedProfile == null) {
      _showError('Please select a profile or all profiles.');
      return;
    }
    
    final profileService = Provider.of<ProfileService>(context, listen: false);
    final crosshairService = Provider.of<CrosshairService>(context, listen: false);
    
    setState(() {
      _exporting = true;
      _exportResult = null;
    });
    
    try {
      if (_allProfilesSelected) {
        final buffer = StringBuffer();
        buffer.writeln(ProfileModel.csvHeader());
        
        for (final profile in profileService.profiles) {
          buffer.write(profile.toCsv(crosshairService.crosshairs));
          buffer.writeln();
        }
        
        await ExportService.copyToClipboard(buffer.toString());
        
        setState(() {
          _exportResult = 'All profiles copied to clipboard';
          _exportSuccess = true;
        });
      } else if (_selectedProfile != null) {
        final buffer = StringBuffer();
        buffer.writeln(ProfileModel.csvHeader());
        buffer.write(_selectedProfile!.toCsv(crosshairService.crosshairs));
        
        await ExportService.copyToClipboard(buffer.toString());
        
        setState(() {
          _exportResult = 'Profile "${_selectedProfile!.name}" copied to clipboard';
          _exportSuccess = true;
        });
      }
    } catch (e) {
      _showError('Copy to clipboard failed: $e');
    } finally {
      setState(() {
        _exporting = false;
      });
    }
  }
  
  /// Show an error message
  void _showError(String message) {
    setState(() {
      _exportResult = message;
      _exportSuccess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileService = Provider.of<ProfileService>(context);
    final crosshairService = Provider.of<CrosshairService>(context);
    
    final profiles = profileService.profiles;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export'),
      ),
      body: Row(
        children: [
          // Left panel
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                right: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(Constants.padding),
                  color: AppTheme.background,
                  child: const Text(
                    'Export Options',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                
                // All profiles option
                Padding(
                  padding: const EdgeInsets.all(Constants.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select what to export:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Constants.paddingSmall),
                      SwitchListTile(
                        title: const Text('All Profiles'),
                        value: _allProfilesSelected,
                        onChanged: _setAllProfilesSelected,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppTheme.primary,
                      ),
                      const Divider(),
                      
                      // Profile selection
                      if (!_allProfilesSelected) ...[
                        const Text(
                          'Or select a specific profile:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: Constants.paddingSmall),
                        DropdownButtonFormField<String?>(
                          decoration: const InputDecoration(
                            labelText: 'Profile',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedProfile?.id,
                          items: profiles.map((profile) {
                            return DropdownMenuItem<String?>(
                              value: profile.id,
                              child: Text(
                                profile.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              final profile = profileService.getProfileById(value);
                              if (profile != null) {
                                _setSelectedProfile(profile);
                              }
                            }
                          },
                        ),
                        const Divider(),
                      ],
                      
                      // Export format
                      const Text(
                        'Export format:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Constants.paddingSmall),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Format',
                          border: OutlineInputBorder(),
                        ),
                        value: _exportFormat,
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'CSV',
                            child: Text('CSV'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _setExportFormat(value);
                          }
                        },
                      ),
                      const SizedBox(height: Constants.padding),
                      
                      // Export buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save),
                              label: const Text('Export'),
                              onPressed: _exporting ? null : _export,
                            ),
                          ),
                          const SizedBox(width: Constants.paddingSmall),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy'),
                              onPressed: _exporting ? null : _copyToClipboard,
                            ),
                          ),
                        ],
                      ),
                      
                      // Export result
                      if (_exportResult != null) ...[
                        const SizedBox(height: Constants.padding),
                        Container(
                          padding: const EdgeInsets.all(Constants.paddingSmall),
                          decoration: BoxDecoration(
                            color: _exportSuccess
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(Constants.borderRadiusSmall),
                          ),
                          child: Text(
                            _exportResult!,
                            style: TextStyle(
                              fontSize: 12,
                              color: _exportSuccess ? Colors.green[300] : Colors.red[300],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Right panel - Preview
          Expanded(
            child: Container(
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
              child: _buildPreview(
                profileService,
                crosshairService,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build the preview
  Widget _buildPreview(
    ProfileService profileService,
    CrosshairService crosshairService,
  ) {
    if (_exporting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_allProfilesSelected) {
      final profiles = profileService.profiles;
      
      if (profiles.isEmpty) {
        return const Center(
          child: Text('No profiles to export'),
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Constants.padding),
            child: Text(
              'Exporting ${profiles.length} profiles',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(Constants.padding),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                final crosshairs = crosshairService.crosshairs
                    .where((c) => profile.crosshairIds.contains(c.id))
                    .toList();
                
                return Card(
                  margin: const EdgeInsets.only(bottom: Constants.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(profile.name),
                        subtitle: Text(
                          '${crosshairs.length} crosshairs',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (crosshairs.isNotEmpty)
                        Container(
                          height: 120,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.padding,
                            vertical: Constants.paddingSmall,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: crosshairs.length,
                            itemBuilder: (context, index) {
                              final crosshair = crosshairs[index];
                              
                              return Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: Constants.paddingSmall),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(Constants.borderRadiusSmall),
                                  border: Border.all(
                                    color: Colors.grey[800]!,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: CrosshairPreview(
                                        crosshair: crosshair,
                                        showInfo: false,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(Constants.borderRadiusSmall - 1),
                                          bottomRight: Radius.circular(Constants.borderRadiusSmall - 1),
                                        ),
                                      ),
                                      child: Text(
                                        crosshair.name,
                                        style: const TextStyle(
                                          fontSize: 10,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
    
    if (_selectedProfile != null) {
      final crosshairs = crosshairService.crosshairs
          .where((c) => _selectedProfile!.crosshairIds.contains(c.id))
          .toList();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Constants.padding),
            child: Text(
              'Exporting profile "${_selectedProfile!.name}"',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          if (crosshairs.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No crosshairs in this profile'),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(Constants.padding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: Constants.padding,
                  mainAxisSpacing: Constants.padding,
                ),
                itemCount: crosshairs.length,
                itemBuilder: (context, index) {
                  final crosshair = crosshairs[index];
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(Constants.borderRadius),
                      border: Border.all(
                        color: Colors.grey[800]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: CrosshairPreview(
                            crosshair: crosshair,
                            showInfo: false,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(Constants.paddingSmall),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(Constants.borderRadius - 1),
                              bottomRight: Radius.circular(Constants.borderRadius - 1),
                            ),
                          ),
                          child: Text(
                            crosshair.name,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      );
    }
    
    return const Center(
      child: Text('Select a profile or all profiles to export'),
    );
  }
}