import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/settings/viewmodel/settings_page_viewmodel.dart';

class SettingsPage extends StatelessWidget {
 SettingsPage({super.key});
  final SettingsViewModel viewModel= SettingsViewModel();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Szymon Molitorys'),
            subtitle: const Text('Zmień swoje dane'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),  
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
          
            },
          ),
          const Divider(),

          ListTile(
            title: const Text('Edytuj Profil'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              
            },
          ),
          ListTile(
            title: const Text('Zmień Język'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
            
            },
          ),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: viewModel.isDarkMode,
              onChanged: (bool value) {
                viewModel.toggleDarkMode(value);
              },
            ),
          ),
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(
              value: viewModel.isNotificationsEnabled,
              onChanged: (bool value) {
                viewModel.toggleNotifications(value);
              },
            ),
          ),
          ListTile(
            title: const Text('Logout'),
            trailing: const Icon(Icons.exit_to_app),
            onTap: () {
              viewModel.logout();
            },
          ),
        ],
      ),
    );
  }
}