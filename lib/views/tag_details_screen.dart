import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/view_models/nfc_view_model.dart';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/models/nfc_record.dart';
import 'package:nfc_app/widgets/tag_details_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class TagDetailsScreen extends StatelessWidget {
  final NFCTag tag;

  const TagDetailsScreen({
    super.key,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NFCViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.tagDetails),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  viewModel.isTagFavorite(tag.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: viewModel.isTagFavorite(tag.id) ? AppColors.favoriteColor : null,
                ),
                onPressed: () => viewModel.toggleFavorite(tag),
                tooltip: AppStrings.favorite,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TagDetailsCard(
                  tag: tag,
                  isFavorite: viewModel.isTagFavorite(tag.id),
                  onToggleFavorite: () => viewModel.toggleFavorite(tag),
                  showActions: false,
                ),
                const SizedBox(height: 24),
                _buildTagInfo(context),
                const SizedBox(height: 24),
                _buildRecordsList(context),
                const SizedBox(height: 24),
                _buildActionsList(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.tagInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, AppStrings.id, tag.id),
            _buildInfoRow(context, AppStrings.technology, tag.technology),
            _buildInfoRow(context, AppStrings.capacity, '${tag.maxSize} ${AppStrings.bytes}'),
            _buildInfoRow(context, AppStrings.writable, tag.isWritable ? AppStrings.yes : AppStrings.no),
            _buildInfoRow(
              context,
              AppStrings.scanned,
              '${tag.scannedAt.day}/${tag.scannedAt.month}/${tag.scannedAt.year} '
                  '${tag.scannedAt.hour}:${tag.scannedAt.minute.toString().padLeft(2, '0')}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList(BuildContext context) {
    if (tag.records.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.records,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...tag.records.map((record) => _buildRecordItem(context, record)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordItem(BuildContext context, NFCRecord record) {
    IconData iconData;
    Color iconColor;

    switch (record.type) {
      case NFCRecordType.text:
        iconData = Icons.text_fields;
        iconColor = AppColors.textTagColor;
        break;
      case NFCRecordType.url:
        iconData = Icons.link;
        iconColor = AppColors.urlTagColor;
        break;
      case NFCRecordType.vCard:
        iconData = Icons.contact_page;
        iconColor = AppColors.contactTagColor;
        break;
      case NFCRecordType.custom:
        iconData = Icons.data_object;
        iconColor = AppColors.customTagColor;
        break;
      case NFCRecordType.unknown:
      default:
        iconData = Icons.help_outline;
        iconColor = AppColors.unknownTagColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconData,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.displayTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  record.displayContent,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsList(BuildContext context) {
    final actions = <Widget>[];

    for (final record in tag.records) {
      switch (record.type) {
        case NFCRecordType.url:
          actions.add(
            ElevatedButton.icon(
              onPressed: () => _launchUrl(context, record.payload),
              icon: const Icon(Icons.open_in_new),
              label: const Text(AppStrings.openUrl),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          );
          break;
        case NFCRecordType.vCard:
          actions.add(
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.contactWouldBeAdded)),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text(AppStrings.addContact),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          );
          break;
        default:
          break;
      }
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.actions,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...actions.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: action,
            )).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.errorOpeningUrl}: $e')),
      );
    }
  }
}
