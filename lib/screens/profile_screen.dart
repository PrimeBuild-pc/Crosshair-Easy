import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../models/crosshair_model.dart';
import '../theme/app_theme.dart';
import '../widgets/crosshair_preview.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileModel initialProfile;

  const ProfileScreen({
    Key? key,
    required this.initialProfile,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileModel _profile;
  late List<ProfileModel> _savedProfiles;
  
  @override
  void initState() {
    super.initState();
    _profile = widget.initialProfile;
    
    // TODO: Load saved profiles from disk
    _savedProfiles = [
      _profile,
      ProfileModel(
        name: 'CS2 Profile',
        description: 'Counter-Strike 2 crosshair settings',
        gameName: 'Counter-Strike 2',
      ),
      ProfileModel(
        name: 'Valorant Profile',
        description: 'Valorant crosshair settings',
        gameName: 'Valorant',
        isFavorite: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create New Profile',
            onPressed: () {
              _showCreateProfileDialog();
            },
          ),
        ],
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: Row(
          children: [
            // Left panel: Profile list
            SizedBox(
              width: 300,
              child: Card(
                margin: const EdgeInsets.all(16),
                color: AppTheme.surfaceColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Saved Profiles',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${_savedProfiles.length} profiles',
                            style: TextStyle(
                              color: AppTheme.secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: AppTheme.dividerColor),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _savedProfiles.length,
                        itemBuilder: (context, index) {
                          final profile = _savedProfiles[index];
                          return ListTile(
                            title: Text(
                              profile.name,
                              style: TextStyle(
                                color: AppTheme.textColor,
                                fontWeight: _profile.id == profile.id
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              profile.description,
                              style: TextStyle(
                                color: AppTheme.secondaryTextColor,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: Icon(
                              Icons.gamepad,
                              color: AppTheme.secondaryTextColor,
                            ),
                            trailing: profile.isFavorite
                                ? Icon(
                                    Icons.star,
                                    color: AppTheme.primaryColor,
                                  )
                                : null,
                            selected: _profile.id == profile.id,
                            selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
                            onTap: () {
                              setState(() {
                                _profile = profile;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Right panel: Current profile details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile header
                    Card(
                      color: AppTheme.surfaceColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _profile.name,
                                        style: TextStyle(
                                          color: AppTheme.textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      if (_profile.gameName != null)
                                        Text(
                                          _profile.gameName!,
                                          style: TextStyle(
                                            color: AppTheme.secondaryTextColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _profile.isFavorite
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: _profile.isFavorite
                                        ? AppTheme.primaryColor
                                        : AppTheme.secondaryTextColor,
                                  ),
                                  tooltip: 'Toggle Favorite',
                                  onPressed: () {
                                    setState(() {
                                      _profile = _profile.copyWith(
                                        isFavorite: !_profile.isFavorite,
                                      );
                                      
                                      // Update in saved profiles list
                                      final index = _savedProfiles.indexWhere(
                                        (p) => p.id == _profile.id,
                                      );
                                      if (index >= 0) {
                                        _savedProfiles[index] = _profile;
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppTheme.secondaryTextColor,
                                  ),
                                  tooltip: 'Edit Profile',
                                  onPressed: () {
                                    _showEditProfileDialog(_profile);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _profile.description,
                              style: TextStyle(
                                color: AppTheme.secondaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Created: ${_formatDate(_profile.createdAt)}',
                              style: TextStyle(
                                color: AppTheme.secondaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Last modified: ${_formatDate(_profile.updatedAt)}',
                              style: TextStyle(
                                color: AppTheme.secondaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Crosshairs section
                    Text(
                      'Crosshairs',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Crosshair grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _profile.crosshairs.length + 1, // +1 for the "Add" button
                      itemBuilder: (context, index) {
                        if (index == _profile.crosshairs.length) {
                          // "Add new" card
                          return _buildAddCrosshairCard();
                        } else {
                          // Crosshair preview card
                          return _buildCrosshairCard(_profile.crosshairs[index]);
                        }
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete Profile'),
                          onPressed: () {
                            _showDeleteConfirmationDialog();
                          },
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text('Save'),
                          onPressed: () {
                            // TODO: Save profile to disk
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format a date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Build a card for a crosshair
  Widget _buildCrosshairCard(CrosshairModel crosshair) {
    return Card(
      color: AppTheme.surfaceColor,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to edit this specific crosshair
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CrosshairPreview(
                  crosshair: crosshair,
                  backgroundType: 'Dark',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                crosshair.name,
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                crosshair.shape,
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a card for adding a new crosshair
  Widget _buildAddCrosshairCard() {
    return Card(
      color: AppTheme.backgroundColor,
      child: InkWell(
        onTap: () {
          setState(() {
            final newCrosshair = CrosshairModel();
            _profile.addCrosshair(newCrosshair);
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Add New Crosshair',
              style: TextStyle(
                color: AppTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Show dialog to create a new profile
  void _showCreateProfileDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final gameController = TextEditingController();
    
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Profile Name',
                  hintText: 'My Awesome Profile',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'A collection of my favorite crosshairs',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: gameController,
                decoration: const InputDecoration(
                  labelText: 'Game (Optional)',
                  hintText: 'Counter-Strike 2',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Create'),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newProfile = ProfileModel(
                  name: nameController.text,
                  description: descriptionController.text,
                  gameName: gameController.text.isNotEmpty
                      ? gameController.text
                      : null,
                );
                
                setState(() {
                  _savedProfiles.add(newProfile);
                  _profile = newProfile;
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // Show dialog to edit a profile
  void _showEditProfileDialog(ProfileModel profile) {
    final nameController = TextEditingController(text: profile.name);
    final descriptionController = TextEditingController(text: profile.description);
    final gameController = TextEditingController(text: profile.gameName ?? '');
    
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Profile Name',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: gameController,
                decoration: const InputDecoration(
                  labelText: 'Game (Optional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final updatedProfile = profile.copyWith(
                  name: nameController.text,
                  description: descriptionController.text,
                  gameName: gameController.text.isNotEmpty
                      ? gameController.text
                      : null,
                );
                
                setState(() {
                  // Update in saved profiles list
                  final index = _savedProfiles.indexWhere(
                    (p) => p.id == profile.id,
                  );
                  if (index >= 0) {
                    _savedProfiles[index] = updatedProfile;
                  }
                  
                  // Update current profile if it's the same
                  if (_profile.id == profile.id) {
                    _profile = updatedProfile;
                  }
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // Show confirmation dialog for deleting a profile
  void _showDeleteConfirmationDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile?'),
        content: Text(
          'Are you sure you want to delete "${_profile.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              setState(() {
                _savedProfiles.removeWhere((p) => p.id == _profile.id);
                
                // Select another profile if available
                if (_savedProfiles.isNotEmpty) {
                  _profile = _savedProfiles.first;
                } else {
                  // Create a default profile if none left
                  final defaultProfile = ProfileModel.defaultProfile();
                  _savedProfiles.add(defaultProfile);
                  _profile = defaultProfile;
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}