import 'package:flutter/material.dart';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/models/nfc_record.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/widgets/app_text.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class TagListItem extends StatelessWidget {
  final NFCTag tag;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const TagListItem({
    super.key,
    required this.tag,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildTagIcon(context),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      tag.primaryContent,
                      type: AppTextType.subtitle1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      '${AppStrings.id}: ${tag.id.substring(0, min(tag.id.length, 10))}... • ${_formatDate(tag.scannedAt)}',
                      type: AppTextType.caption,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.favoriteColor : null,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagIcon(BuildContext context) {
    Color iconColor;
    IconData iconData;

    switch (tag.primaryType) {
      case NFCRecordType.text:
        iconColor = AppColors.textTagColor;
        iconData = Icons.text_fields;
        break;
      case NFCRecordType.url:
        iconColor = AppColors.urlTagColor;
        iconData = Icons.link;
        break;
      case NFCRecordType.vCard:
        iconColor = AppColors.contactTagColor;
        iconData = Icons.contact_page;
        break;
      case NFCRecordType.custom:
        iconColor = AppColors.customTagColor;
        iconData = Icons.data_object;
        break;
      case NFCRecordType.unknown:
      default:
        iconColor = AppColors.unknownTagColor;
        iconData = Icons.help_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${AppStrings.today} ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return '${AppStrings.yesterday} ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${AppStrings.daysAgo}';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }

  int min(int a, int b) => a < b ? a : b;
}
