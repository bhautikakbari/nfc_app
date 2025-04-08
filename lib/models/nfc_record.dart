enum NFCRecordType {
  text,
  url,
  vCard,
  custom,
  unknown,
}

class NFCRecord {
  final String id;
  final NFCRecordType type;
  final String payload;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  NFCRecord({
    required this.id,
    required this.type,
    required this.payload,
    required this.timestamp,
    this.metadata,
  });

  factory NFCRecord.fromMap(Map<String, dynamic> map) {
    return NFCRecord(
      id: map['id'] ?? '',
      type: NFCRecordType.values.firstWhere(
            (e) => e.toString() == map['type'],
        orElse: () => NFCRecordType.unknown,
      ),
      payload: map['payload'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  String get displayTitle {
    switch (type) {
      case NFCRecordType.text:
        return 'Text';
      case NFCRecordType.url:
        return 'URL';
      case NFCRecordType.vCard:
        return 'Contact';
      case NFCRecordType.custom:
        return 'Custom Data';
      case NFCRecordType.unknown:
      default:
        return 'Unknown';
    }
  }

  String get displayContent {
    switch (type) {
      case NFCRecordType.text:
        return payload;
      case NFCRecordType.url:
        return payload;
      case NFCRecordType.vCard:
      // Parse vCard format for display
        return _parseVCard(payload);
      case NFCRecordType.custom:
      case NFCRecordType.unknown:
      default:
        return payload;
    }
  }

  String _parseVCard(String vCardData) {
    // Simple vCard parser - in a real app, this would be more robust
    final nameMatch = RegExp(r'FN:(.*?)(?:\r\n|\r|\n)').firstMatch(vCardData);
    final name = nameMatch?.group(1) ?? 'Unknown';

    final emailMatch = RegExp(r'EMAIL:(.*?)(?:\r\n|\r|\n)').firstMatch(vCardData);
    final email = emailMatch?.group(1) ?? '';

    return '$name${email.isNotEmpty ? ' • $email' : ''}';
  }
}
