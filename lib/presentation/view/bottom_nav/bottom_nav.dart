import 'package:data_app/data/shared_preference.dart';
import 'package:data_app/main.dart';
import 'package:data_app/model/data_model/users_response_model.dart';
import 'package:data_app/presentation/view/bottom_nav/discover_screen.dart';
import 'package:data_app/presentation/view/bottom_nav/profile_screen.dart';
import 'package:data_app/presentation/view/auth/reset_password_screen.dart';
import 'package:data_app/presentation/view/bottom_nav/setting_screen.dart';
import 'package:data_app/presentation/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers/constants/app_color.dart';
import '../../../model/common_model/bottom_nav_model.dart';
import 'buddies_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var prefs = SharedPreference();
  late UserViewModel userViewModel;

  final List<BottomNavigationModel> bottomNav = [
    BottomNavigationModel(
      title: "Discover",
      icon: const Icon(Icons.home),
      screen: const DiscoverScreen()
    ),
    BottomNavigationModel(
      title: "Buddies",
      icon: const Icon(Icons.search),
      screen: const BuddiesScreen(),
    ),
    BottomNavigationModel(
      title: "Settings",
      icon: const Icon(Icons.settings),
      screen: const SettingsScreen(),
    ),
    BottomNavigationModel(
      title: "Profile",
      icon: const Icon(Icons.person),
      screen: const ProfileScreen(),
    )
  ];

  @override
  Scaffold build(BuildContext context) {
    userViewModel = context.watch<UserViewModel>();
    setUser();


    return Scaffold(
      body: bottomNav[userViewModel.pageIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: userViewModel.pageIndex,
        onTap: (index) {
          userViewModel.setIndex(index);
        },
        items: bottomNav.map((e) {
          return BottomNavigationBarItem(
            label: e.title,
            icon: e.icon,
          );
        }).toList(),
      ),
    );
  }

  setUser() async {
    userViewModel.setUser(UserModel.fromJson(await prefs.getLoggedIn()));
  }
}
