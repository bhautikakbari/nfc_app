import 'package:nfc_app/models/nfc_record.dart';

class NFCTag {
  final String id;
  final String technology;
  final int maxSize;
  final bool isWritable;
  final List<NFCRecord> records;
  final DateTime scannedAt;

  NFCTag({
    required this.id,
    required this.technology,
    required this.maxSize,
    required this.isWritable,
    required this.records,
    required this.scannedAt,
  });

  factory NFCTag.fromMap(Map<String, dynamic> map) {
    return NFCTag(
      id: map['id'] ?? '',
      technology: map['technology'] ?? 'Unknown',
      maxSize: map['maxSize'] ?? 0,
      isWritable: map['isWritable'] ?? false,
      records: (map['records'] as List?)
          ?.map((record) => NFCRecord.fromMap(record))
          .toList() ?? [],
      scannedAt: DateTime.parse(map['scannedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'technology': technology,
      'maxSize': maxSize,
      'isWritable': isWritable,
      'records': records.map((record) => record.toMap()).toList(),
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  String get primaryContent {
    if (records.isEmpty) {
      return 'Empty Tag';
    }
    return records.first.displayContent;
  }

  NFCRecordType get primaryType {
    if (records.isEmpty) {
      return NFCRecordType.unknown;
    }
    return records.first.type;
  }
}
