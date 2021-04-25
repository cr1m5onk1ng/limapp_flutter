import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:limapp/application/providers/database/database_providers.dart';
import 'package:limapp/application/providers/reader/reader_providers.dart';
import 'package:limapp/application/providers/video/video_providers.dart';
import 'package:limapp/screens/articles_screen.dart';
import 'package:limapp/screens/home_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'screens.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ArticlesScreen(),
  ];

  final List<IconData> _icons = [
    MdiIcons.home,
    MdiIcons.youtube,
    MdiIcons.web,
  ];

  final List<Color> _selectedColors = [
    Colors.yellowAccent[700],
    Colors.red,
    Colors.lightBlue,
  ];

  final HashMap<int, List<Color>> _iconsColorsMap = HashMap.from({
    0: [
      Colors.yellow[400],
      Colors.red[200],
      Colors.lightBlue[100],
    ],
    1: [
      Colors.black.withOpacity(0.6),
      Colors.black.withOpacity(0.6),
      Colors.black.withOpacity(0.6),
    ],
    2: [
      Colors.black.withOpacity(0.6),
      Colors.black.withOpacity(0.6),
      Colors.black.withOpacity(0.6),
    ],
  });

  final List<Color> tabsColors = [
    Colors.transparent,
    Colors.white,
    Colors.white
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _screens.length,
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: tabsColors[_selectedIndex],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                  onTap: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  indicatorPadding: EdgeInsets.zero,
                  indicator: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  tabs: _icons
                      .asMap()
                      .map((i, e) => MapEntry(
                            i,
                            Tab(
                              icon: Icon(
                                e,
                                size: 30,
                                color: i == _selectedIndex
                                    ? _selectedColors[_selectedIndex]
                                    : _iconsColorsMap[_selectedIndex][i],
                              ),
                            ),
                          ))
                      .values
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomTabBar({Key key, this.icons, this.selectedIndex, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.grey[700],
      Colors.redAccent,
      Colors.blueAccent,
    ];
    return TabBar(
      onTap: onTap,
      indicatorPadding: EdgeInsets.zero,
      indicator: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors[selectedIndex],
            width: 3,
          ),
        ),
      ),
      tabs: icons
          .asMap()
          .map((i, e) => MapEntry(
                i,
                Tab(
                  icon: Icon(
                    e,
                    size: 30,
                    color: i == selectedIndex
                        ? colors[selectedIndex]
                        : Colors.grey[400],
                  ),
                ),
              ))
          .values
          .toList(),
    );
  }
}
