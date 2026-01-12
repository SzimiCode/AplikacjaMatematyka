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
          const Divider(),
          ListTile(
            title: const Text(
              'Zresetuj postęp',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Usuń wszystkie zdobyte ognie i postęp w kursach',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Resetowanie postępu'),
                  content: const Text(
                    'Czy na pewno chcesz zresetować cały postęp?\n\n',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Anuluj'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        viewModel.resetProgress(context);
                      },
                      child: const Text(
                        'Resetuj postęp',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
                title: const Text('Licencje'),
                trailing: const Icon(Icons.description),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Aplikacja Matematyka',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(Icons.calculate),
                    applicationLegalese: '© 2026 Szymon Molitorys, Jakub Stępień, Mateusz Roździński\n'
                        'Wszelkie prawa zastrzeżone.\n\n'
                        'Aplikacja oraz jej kod źródłowy są chronione prawem autorskim. '
                        'Wykorzystane biblioteki open-source podlegają ich własnym licencjom.',
                  );
                },
              ),

          ListTile(
            title: const Text('Logout'),
            trailing: const Icon(Icons.exit_to_app),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Wylogowanie'),
                  content: const Text('Czy na pewno chcesz się wylogować?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Anuluj'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        viewModel.logout(context);
                      },
                      child: const Text('Wyloguj', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
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