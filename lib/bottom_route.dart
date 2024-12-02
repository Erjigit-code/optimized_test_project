import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_transport_budget_95t/main/main_screen.dart';

class ButtomRoute extends StatefulWidget {
  const ButtomRoute({super.key});

  @override
  State<ButtomRoute> createState() => _ButtomRouteState();
}

class _ButtomRouteState extends State<ButtomRoute> {
  int selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const MainScreen(),
    const Text("Screen 2"),
    const Text("Screen 3"),
    const Text('Settings Screen'),
  ];

  // Кеширование иконок
  late final Map<String, Widget> _iconCache;

  @override
  void initState() {
    super.initState();
    _iconCache = {
      'Chart': _buildCachedSvg('assets/svg/Chart.svg'),
      'Routing 4': _buildCachedSvg('assets/svg/Routing 4.svg'),
      'Globus': _buildCachedSvg('assets/svg/Globus.svg'),
      'Settings': _buildCachedSvg('assets/svg/Settings.svg'),
    };
  }

  Widget _buildCachedSvg(String assetName) {
    return SvgPicture.asset(
      assetName,
      width: 24.w,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff121213),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildBottomNavItem('Chart', 0),
          _buildBottomNavItem('Routing 4', 1),
          _buildBottomNavItem('Globus', 2),
          _buildBottomNavItem('Settings', 3),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(String svgName, int index) {
    return BottomNavigationBarItem(
      icon: RepaintBoundary(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            selectedIndex == index ? const Color(0xff000DFF) : Colors.grey,
            BlendMode.srcIn,
          ),
          child: _iconCache[svgName]!,
        ),
      ),
      label: '',
    );
  }

  void _onItemTapped(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });
    }
  }
}
