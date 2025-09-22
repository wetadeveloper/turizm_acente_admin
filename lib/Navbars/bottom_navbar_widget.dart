import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Navbars/home_page.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/view/reklamlar_view.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/view/kampanyalar_view.dart';

class BottomNavBarWidget extends StatefulWidget {
  final int index;
  const BottomNavBarWidget({super.key, required this.index});

  @override
  BottomNavBarWidgetState createState() => BottomNavBarWidgetState();
}

class BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  final Color _unselectedItemColor = Colors.grey;
  final Color _selectedItemColor = Colors.orange;
  late int _selectedIndex;
  final List<Widget> _pages = [
    const HomePage(),
    const KampanyalarView(),
    const ReklamlarView(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Anasayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.ac_unit),
          label: 'Kampanyalar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.ad_units_rounded),
          label: 'Reklam',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: _selectedItemColor,
      unselectedItemColor: _unselectedItemColor,
      onTap: _onItemTapped,
    );
  }
}
