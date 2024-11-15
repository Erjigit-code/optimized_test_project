import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_transport_budget_95t/main/main_screen.dart';
import 'package:my_transport_budget_95t/settings/settings_view.dart';

class ButtomRoute extends StatefulWidget {
  const ButtomRoute({super.key});

  @override
  State<ButtomRoute> createState() => _ButtomRouteState();
}

class _ButtomRouteState extends State<ButtomRoute> {
  int selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    Text("sdfgbsdbf"),
    Text("sdfgbsdbf"),
    Text('kfgno')
    // const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(selectedIndex),
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

  BottomNavigationBarItem _buildBottomNavItem(
    String svgName,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/svg/$svgName.svg',
        width: 24.w,
        color: selectedIndex == index
            ? const Color(0xff000DFF)
            : const Color(0xffFFFFFF).withOpacity(0.6),
      ),
      label: '',
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
