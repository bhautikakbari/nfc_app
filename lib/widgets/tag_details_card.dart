import 'package:flutter/material.dart';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/models/nfc_record.dart';
import 'package:nfc_app/widgets/app_text.dart';
import 'package:nfc_app/widgets/app_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class TagDetailsCard extends StatelessWidget {
  final NFCTag tag;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final bool showActions;

  const TagDetailsCard({
    super.key,
    required this.tag,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTagContent(context),
                if (showActions) ...[
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    Color headerColor;
    IconData headerIcon;

    switch (tag.primaryType) {
      case NFCRecordType.text:
        headerColor = AppColors.textTagColor;
        headerIcon = Icons.text_fields;
        break;
      case NFCRecordType.url:
        headerColor = AppColors.urlTagColor;
        headerIcon = Icons.link;
        break;
      case NFCRecordType.vCard:
        headerColor = AppColors.contactTagColor;
        headerIcon = Icons.contact_page;
        break;
      case NFCRecordType.custom:
        headerColor = AppColors.customTagColor;
        headerIcon = Icons.data_object;
        break;
      case NFCRecordType.unknown:
      default:
        headerColor = AppColors.unknownTagColor;
        headerIcon = Icons.help_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: headerColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            headerIcon,
            color: headerColor,
          ),
          const SizedBox(width: 8),
          AppText(
            _getTagTypeLabel(),
            fontWeight: FontWeight.bold,
            color: headerColor,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.favoriteColor : Colors.grey,
            ),
            onPressed: onToggleFavorite,
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
        ],
      ),
    );
  }

  Widget _buildTagContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          tag.primaryContent,
          type: AppTextType.headline5,
        ),
        const SizedBox(height: 8),
        AppText(
          '${AppStrings.id}: ${tag.id}',
          type: AppTextType.caption,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        AppText(
          '${AppStrings.technology}: ${tag.technology}',
          type: AppTextType.caption,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          text: AppStrings.copy,
          onPressed: () {
            // In a real app, this would copy the tag content to clipboard
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(AppStrings.contentCopied)),
            );
          },
          type: AppButtonType.outlined,
        ),
        const SizedBox(width: 8),
        AppButton(
          text: AppStrings.share,
          onPressed: () {
            // In a real app, this would share the tag content
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(AppStrings.sharingNotImplemented)),
            );
          },
          type: AppButtonType.primary,
        ),
      ],
    );
  }

  String _getTagTypeLabel() {
    switch (tag.primaryType) {
      case NFCRecordType.text:
        return AppStrings.text;
      case NFCRecordType.url:
        return AppStrings.url;
      case NFCRecordType.vCard:
        return AppStrings.contact;
      case NFCRecordType.custom:
        return AppStrings.customData;
      case NFCRecordType.unknown:
      default:
        return AppStrings.unknown;
    }
  }
}
