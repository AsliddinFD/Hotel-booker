import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/orders.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/utils/functions.dart';
import 'package:frontend/widget/drawer_widget.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int activePageIndex = 0;

  void selectTab(int currentPageIndex) {
    setState(() {
      activePageIndex = currentPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();
    var activePageTitle = 'Rooms';
    if (activePageIndex == 1) {
      activePage = const OrdersScreen();
      activePageTitle = 'Orders';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          token.isEmpty
              ? TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Log in'))
              : const Icon(CupertinoIcons.profile_circled),
        ],
      ),
      drawer: const DrawerWidget(),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectTab,
        currentIndex: activePageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.door_back_door_sharp,
            ),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.receipt,
            ),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
