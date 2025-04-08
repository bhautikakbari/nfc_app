import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/view_models/nfc_view_model.dart';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/models/nfc_record.dart';
import 'package:nfc_app/widgets/tag_details_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nfc_app/constants/app_strings.dart';
import 'package:nfc_app/constants/app_colors.dart';
import 'package:nfc_app/widgets/app_text.dart';
import 'package:nfc_app/widgets/app_button.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  NFCViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely store a reference to the view model
    _viewModel = Provider.of<NFCViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    // Stop NFC session when leaving the screen
    if (_viewModel != null && _viewModel!.isScanning) {
      _viewModel!.stopSession();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NFCViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: AppText(
              AppStrings.scanTitle,
              type: AppTextType.headline6,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _buildContent(viewModel),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildScanButton(viewModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(NFCViewModel viewModel) {
    if (viewModel.isScanning) {
      return _buildScanningView();
    } else if (viewModel.lastScannedTag != null) {
      return _buildTagDetailsView(viewModel, viewModel.lastScannedTag!);
    } else {
      return _buildEmptyView();
    }
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.nfc,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            AppStrings.noTagScanned,
            type: AppTextType.headline5,
          ),
          const SizedBox(height: 8),
          AppText(
            AppStrings.tapToScan,
            type: AppTextType.bodyMedium,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          AppText(
            AppStrings.scanningForTags,
            type: AppTextType.headline5,
          ),
          const SizedBox(height: 8),
          AppText(
            AppStrings.holdNearTag,
            type: AppTextType.bodyMedium,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildTagDetailsView(NFCViewModel viewModel, NFCTag tag) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TagDetailsCard(
            tag: tag,
            isFavorite: viewModel.isTagFavorite(tag.id),
            onToggleFavorite: () => viewModel.toggleFavorite(tag),
          ),
          const SizedBox(height: 16),
          if (tag.records.isNotEmpty) ...[
            AppText(
              AppStrings.actions,
              type: AppTextType.subtitle1,
            ),
            const SizedBox(height: 8),
            _buildActionCards(tag.records),
          ],
        ],
      ),
    );
  }

  Widget _buildActionCards(List<NFCRecord> records) {
    return Column(
      children: records.map((record) {
        switch (record.type) {
          case NFCRecordType.url:
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.link, color: AppColors.urlTagColor),
                title: AppText(AppStrings.openUrl, type: AppTextType.subtitle1),
                subtitle: AppText(record.payload, type: AppTextType.bodySmall),
                onTap: () => _launchUrl(record.payload),
              ),
            );
          case NFCRecordType.vCard:
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.contact_page, color: AppColors.contactTagColor),
                title: AppText(AppStrings.addContact, type: AppTextType.subtitle1),
                subtitle: AppText(record.displayContent, type: AppTextType.bodySmall),
                onTap: () {
                  // In a real app, this would add the contact to the device
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: AppText(AppStrings.contactWouldBeAdded)),
                  );
                },
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      }).toList(),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: AppText('${AppStrings.errorOpeningUrl}: $e')),
      );
    }
  }

  Widget _buildScanButton(NFCViewModel viewModel) {
    return AppButton(
      text: viewModel.isScanning ? AppStrings.stopScan : AppStrings.startScan,
      onPressed: viewModel.isScanning ? viewModel.stopSession : viewModel.startScan,
      type: AppButtonType.primary,
      fullWidth: true,
      icon: viewModel.isScanning ? Icons.stop : Icons.nfc,
    );
  }
}
