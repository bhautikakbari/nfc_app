import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/view_models/nfc_view_model.dart';
import 'package:nfc_app/views/scan_screen.dart';
import 'package:nfc_app/views/write_screen.dart';
import 'package:nfc_app/views/history_screen.dart';
import 'package:nfc_app/views/settings_screen.dart';
import 'package:nfc_app/constants/app_strings.dart';
import 'package:nfc_app/widgets/app_text.dart';
import 'package:nfc_app/widgets/app_button.dart';
import 'package:nfc_app/widgets/app_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ScanScreen(),
    const WriteScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Check NFC availability when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNfcAvailability();
    });
  }

  Future<void> _checkNfcAvailability() async {
    final viewModel = Provider.of<NFCViewModel>(context, listen: false);
    if (!viewModel.isNfcAvailable) {
      _showNfcNotAvailableDialog();
    }
  }

  void _showNfcNotAvailableDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => WillPopScope(
        // Prevent dismissing with back button
        onWillPop: () async => false,
        child: AlertDialog(
          title: AppText(
            AppStrings.nfcNotAvailable,
            type: AppTextType.headline6,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                AppStrings.nfcNotAvailableDesc,
                type: AppTextType.bodyMedium,
              ),
              const SizedBox(height: 16),
              AppText(
                'This app requires NFC to function properly. You can:',
                type: AppTextType.bodyMedium,
              ),
              const SizedBox(height: 8),
              AppText(
                '• Enable NFC in your device settings if available',
                type: AppTextType.bodyMedium,
              ),
              AppText(
                '• Use a device that supports NFC',
                type: AppTextType.bodyMedium,
              ),
              AppText(
                '• Continue in demo mode with limited functionality',
                type: AppTextType.bodyMedium,
              ),
            ],
          ),
          actions: [
            AppButton(
              text: 'Exit App',
              onPressed: () {
                SystemNavigator.pop(); // Close the app
              },
              type: AppButtonType.outlined,
            ),
            AppButton(
              text: 'Continue in Demo Mode',
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: AppButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          AppBottomNavItem(
            icon: Icons.nfc,
            label: AppStrings.scanTab,
          ),
          AppBottomNavItem(
            icon: Icons.edit,
            label: AppStrings.writeTab,
          ),
          AppBottomNavItem(
            icon: Icons.history,
            label: AppStrings.historyTab,
          ),
          AppBottomNavItem(
            icon: Icons.settings,
            label: AppStrings.settingsTab,
          ),
        ],
      ),
    );
  }
}
