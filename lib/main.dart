import 'package:flutter/material.dart';

void main() {
  runApp(const CrosshairStudio());
}

/// The main application widget
class CrosshairStudio extends StatelessWidget {
  /// Create a new CrosshairStudio application
  const CrosshairStudio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crosshair Studio',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.orange,
        ),
      ),
      home: const CrosshairHome(),
    );
  }
}

/// Home screen widget
class CrosshairHome extends StatefulWidget {
  /// Create a new home screen
  const CrosshairHome({Key? key}) : super(key: key);

  @override
  State<CrosshairHome> createState() => _CrosshairHomeState();
}

class _CrosshairHomeState extends State<CrosshairHome> {
  int _selectedIndex = 0;

  final List<_NavigationItem> _navigationItems = [
    _NavigationItem(
      title: 'Home',
      icon: Icons.home,
      screen: const _HomeContent(),
    ),
    _NavigationItem(
      title: 'Profiles',
      icon: Icons.person,
      screen: const _ProfileContent(),
    ),
    _NavigationItem(
      title: 'Settings',
      icon: Icons.settings,
      screen: const _SettingsContent(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crosshair Studio'),
        backgroundColor: Colors.black87,
      ),
      body: Row(
        children: [
          // Navigation rail
          NavigationRail(
            backgroundColor: Colors.black87,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.selected,
            destinations: _navigationItems.map((item) => 
              NavigationRailDestination(
                icon: Icon(item.icon),
                label: Text(item.title),
              )
            ).toList(),
            selectedIconTheme: const IconThemeData(
              color: Colors.orange,
            ),
          ),
          
          // Divider
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: Colors.grey[800],
          ),
          
          // Main content area
          Expanded(
            child: _navigationItems[_selectedIndex].screen,
          ),
        ],
      ),
    );
  }
}

/// Navigation item for the app shell
class _NavigationItem {
  /// The title of the navigation item
  final String title;
  
  /// The icon of the navigation item
  final IconData icon;
  
  /// The screen to show when this item is selected
  final Widget screen;
  
  /// Create a new navigation item
  _NavigationItem({
    required this.title,
    required this.icon,
    required this.screen,
  });
}

/// Home content widget
class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.gps_fixed,
              color: Colors.orange,
              size: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Crosshair Studio',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create, customize and export gaming crosshairs',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Create New Crosshair',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Profile content widget
class _ProfileContent extends StatelessWidget {
  const _ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Text(
          'Profiles',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Settings content widget
class _SettingsContent extends StatelessWidget {
  const _SettingsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}