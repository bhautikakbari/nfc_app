import 'package:nfc_app/models/nfc_record.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TagUtils {
  /// Get color for a tag type
  static Color getColorForTagType(NFCRecordType type) {
    switch (type) {
      case NFCRecordType.text:
        return AppColors.textTagColor;
      case NFCRecordType.url:
        return AppColors.urlTagColor;
      case NFCRecordType.vCard:
        return AppColors.contactTagColor;
      case NFCRecordType.custom:
        return AppColors.customTagColor;
      case NFCRecordType.unknown:
      default:
        return AppColors.unknownTagColor;
    }
  }

  /// Get icon for a tag type
  static IconData getIconForTagType(NFCRecordType type) {
    switch (type) {
      case NFCRecordType.text:
        return Icons.text_fields;
      case NFCRecordType.url:
        return Icons.link;
      case NFCRecordType.vCard:
        return Icons.contact_page;
      case NFCRecordType.custom:
        return Icons.data_object;
      case NFCRecordType.unknown:
      default:
        return Icons.help_outline;
    }
  }

  /// Format tag ID for display
  static String formatTagId(String id, {int maxLength = 10}) {
    if (id.length <= maxLength) {
      return id;
    }
    return '${id.substring(0, maxLength)}...';
  }

  /// Check if a URL is valid
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'http' || uri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }

  /// Ensure URL has proper format
  static String ensureProperUrlFormat(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }
}
