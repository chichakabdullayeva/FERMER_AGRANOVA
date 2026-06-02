import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../tabs/feed_screen.dart';
import '../tabs/messages_screen.dart';
import '../tabs/groups_screen.dart';
import '../tabs/weather_screen.dart';
import '../tabs/support_screen.dart';
import '../../config/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const FeedScreen(),
      const MessagesScreen(),
      const GroupsScreen(),
      const WeatherScreen(),
      const SupportScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: loc.tabAnaSehife,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_outlined),
            activeIcon: const Icon(Icons.chat),
            label: loc.tabSohbetler,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.groups_outlined),
            activeIcon: const Icon(Icons.groups),
            label: loc.tabQruplar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.cloud_outlined),
            activeIcon: const Icon(Icons.cloud),
            label: loc.tabHava,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.support_agent_outlined),
            activeIcon: const Icon(Icons.support_agent),
            label: loc.tabDastek,
          ),
        ],
      ),
    );
  }
}
