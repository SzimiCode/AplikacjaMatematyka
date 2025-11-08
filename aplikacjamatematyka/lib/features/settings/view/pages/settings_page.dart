import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/settings/viewmodel/settings_page_viewmodel.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

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
            title: const Text('Dark Mode'),
           trailing:  ValueListenableBuilder(
            valueListenable: isDarkModifier,
            //Switch wymaga value jakiegoś a onChanged wymaga boola, więc możemy dać losowe value, a w OnChange dac podłoge która oznacza nic
             builder: (context, isDark, _) {
                return Switch(
                  value: isDark,
                  onChanged: (_) => viewModel.toggleDarkMode(),
                );
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: ElevatedButton(
          onPressed: viewModel.onBackButtonPressed,
          child: const Text('Cofnij do strony głównej'),
        ),
      ),
    );
  }
}