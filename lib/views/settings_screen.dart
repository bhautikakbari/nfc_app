import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nfc_app/constants/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/widgets/app_text.dart';
import 'package:nfc_app/controllers/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _saveHistory = true;
  bool _autoOpenUrls = false;

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          AppStrings.settingsTitle,
          type: AppTextType.headline6,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(AppStrings.appearance),
          SwitchListTile(
            title: const AppText(AppStrings.darkMode),
            subtitle: const AppText(AppStrings.enableDarkTheme, type: AppTextType.bodySmall),
            value: themeController.isDarkMode,
            onChanged: (value) {
              themeController.setDarkMode(value);
            },
          ),
          _buildSectionHeader(AppStrings.nfcSettings),
          SwitchListTile(
            title: const AppText(AppStrings.saveHistory),
            subtitle: const AppText(AppStrings.saveHistoryDesc, type: AppTextType.bodySmall),
            value: _saveHistory,
            onChanged: (value) {
              setState(() {
                _saveHistory = value;
              });
            },
          ),
          SwitchListTile(
            title: const AppText(AppStrings.autoOpenUrls),
            subtitle: const AppText(AppStrings.autoOpenUrlsDesc, type: AppTextType.bodySmall),
            value: _autoOpenUrls,
            onChanged: (value) {
              setState(() {
                _autoOpenUrls = value;
              });
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: AppText(
        title,
        type: AppTextType.subtitle1,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

}
