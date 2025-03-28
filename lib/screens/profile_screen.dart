import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import '../services/crosshair_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/crosshair_preview.dart';

/// The profile screen
class ProfileScreen extends StatefulWidget {
  /// Create a new profile screen
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// The selected profile
  ProfileModel? _selectedProfile;
  
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
  
  /// Create a new profile
  void _createNewProfile() {
    final profileService = Provider.of<ProfileService>(context, listen: false);
    
    // Show dialog
    showDialog(
      context: context,
      builder: (context) {
        String name = 'New Profile';
        String description = '';
        
        return AlertDialog(
          title: const Text('Create New Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  name = value;
                },
                controller: TextEditingController(text: name),
              ),
              const SizedBox(height: Constants.padding),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  description = value;
                },
                controller: TextEditingController(text: description),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newProfile = ProfileModel(
                  name: name,
                  description: description,
                );
                
                profileService.addProfile(newProfile).then((profile) {
                  setState(() {
                    _selectedProfile = profile;
                  });
                  
                  profileService.setActiveProfile(profile.id);
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
  
  /// Edit the selected profile
  void _editProfile() {
    if (_selectedProfile == null) {
      return;
    }
    
    final profileService = Provider.of<ProfileService>(context, listen: false);
    
    // Show dialog
    showDialog(
      context: context,
      builder: (context) {
        String name = _selectedProfile!.name;
        String description = _selectedProfile!.description;
        
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  name = value;
                },
                controller: TextEditingController(text: name),
              ),
              const SizedBox(height: Constants.padding),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  description = value;
                },
                controller: TextEditingController(text: description),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedProfile = _selectedProfile!.copyWith(
                  name: name,
                  description: description,
                );
                
                profileService.updateProfile(updatedProfile);
                
                setState(() {
                  _selectedProfile = updatedProfile;
                });
                
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
  
  /// Delete the selected profile
  void _deleteProfile() {
    if (_selectedProfile == null) {
      return;
    }
    
    final profileService = Provider.of<ProfileService>(context, listen: false);
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Profile'),
          content: Text('Are you sure you want to delete the profile "${_selectedProfile!.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                profileService.deleteProfile(_selectedProfile!.id);
                
                setState(() {
                  _selectedProfile = profileService.activeProfile;
                });
                
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  
  /// Set the active profile
  void _setActiveProfile(ProfileModel profile) {
    final profileService = Provider.of<ProfileService>(context, listen: false);
    
    profileService.setActiveProfile(profile.id);
    
    setState(() {
      _selectedProfile = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileService = Provider.of<ProfileService>(context);
    final crosshairService = Provider.of<CrosshairService>(context);
    
    final profiles = profileService.profiles;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewProfile,
            tooltip: 'Create new profile',
          ),
        ],
      ),
      body: Row(
        children: [
          // Profiles list
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
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(Constants.padding),
                  color: AppTheme.background,
                  child: const Row(
                    children: [
                      Text(
                        'My Profiles',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      final isActive = profile.id == (_selectedProfile?.id ?? '');
                      
                      return ListTile(
                        title: Text(profile.name),
                        subtitle: Text(
                          '${profile.crosshairIds.length} crosshairs',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                        selected: isActive,
                        selectedTileColor: AppTheme.primary.withOpacity(0.2),
                        onTap: () => _setActiveProfile(profile),
                        trailing: isActive
                            ? const Icon(
                                Icons.check_circle,
                                color: AppTheme.primary,
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Profile details
          Expanded(
            child: _selectedProfile != null
                ? _buildProfileDetails(
                    _selectedProfile!,
                    crosshairService,
                    profileService,
                  )
                : const Center(
                    child: Text('Select or create a profile'),
                  ),
          ),
        ],
      ),
    );
  }
  
  /// Build the profile details
  Widget _buildProfileDetails(
    ProfileModel profile,
    CrosshairService crosshairService,
    ProfileService profileService,
  ) {
    final crosshairs = crosshairService.crosshairs
        .where((c) => profile.crosshairIds.contains(c.id))
        .toList();
    
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(Constants.padding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      if (profile.description.isNotEmpty)
                        Text(
                          profile.description,
                          style: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                      const SizedBox(height: Constants.paddingSmall),
                      Text(
                        'Last modified: ${_formatDate(profile.lastModified)}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editProfile,
                  tooltip: 'Edit profile',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteProfile,
                  tooltip: 'Delete profile',
                ),
              ],
            ),
          ),
          
          // Crosshairs
          Expanded(
            child: crosshairs.isEmpty
                ? const Center(
                    child: Text('No crosshairs in this profile'),
                  )
                : GridView.builder(
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
                      final isActive = crosshair.id == profile.activeCrosshairId;
                      
                      return InkWell(
                        onTap: () {
                          profileService.setActiveCrosshairForProfile(
                            profile.id,
                            crosshair.id,
                          );
                          
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(Constants.borderRadius),
                            border: Border.all(
                              color: isActive ? AppTheme.primary : Colors.grey[800]!,
                              width: isActive ? 2 : 1,
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
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(Constants.borderRadius - 1),
                                    bottomRight: Radius.circular(Constants.borderRadius - 1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        crosshair.name,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isActive)
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppTheme.primary,
                                        size: 16,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  /// Format a date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}