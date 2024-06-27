
import 'package:chapa_tu_bus_app/account_management/presentation/widgets/profile/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final void Function() onProfileTap;
  final void Function() onSettingsTap;
  final void Function() onLogoutTap;
  const MyDrawer(
      {super.key,
      required this.onProfileTap,
      required this.onSettingsTap,
      required this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header
              const DrawerHeader(
                child: Icon(Icons.person, color: Colors.black, size: 64),
              ),

              //home list tile
              MyListTile(
                icon: Icons.home,
                title: 'Home',
                onTap: () => Navigator.pop(context),
              ),

              //profile list tile
              MyListTile(
                icon: Icons.person,
                title: 'Profile',
                onTap: () => onProfileTap(),
              ),

              //settings list tile
              MyListTile(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () => onSettingsTap(),
              ),
            ],
          ),

          //logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => onLogoutTap(),
            ),
          ),
        ],
      ),
    );
  }
}
