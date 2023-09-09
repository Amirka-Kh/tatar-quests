import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quest_peak/config/app_locale_extension.dart';
import 'package:quest_peak/pages/add_quest/add_quest.dart';
import 'package:quest_peak/pages/favorites/favorites.dart';
import 'package:quest_peak/pages/main/main_page.dart';
import 'package:quest_peak/pages/settings/settings.dart';

class Home2Page extends ConsumerStatefulWidget {
  const Home2Page({super.key});

  @override
  ConsumerState<Home2Page> createState() => _Home2Page();
}

class _Home2Page extends ConsumerState<Home2Page> {
  final bottomBarPages = const [
    MainPage(),
    AddQuestPage(),
    FavoritesPage(),
    SettingsPage(),
  ];
  int _currentBottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentBottomBarIndex = index;
          });
        },
        unselectedItemColor: const Color(0xB3000000),
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/Home.svg'),
            label: context.locale.home,
          ),
          BottomNavigationBarItem(
            // icon: SvgPicture.asset('assets/icon/Bag.svg'),
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 35,
            ),
            label: context.locale.addQuest,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/Heart.svg'),
            label: context.locale.savedSuggestions,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/Setting.svg'),
            label: context.locale.settings,
          ),
        ],
      ),
      body: bottomBarPages[_currentBottomBarIndex],
    );
  }
}
