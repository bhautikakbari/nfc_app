import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/models/nfc_record.dart';
import 'package:nfc_app/services/nfc_service.dart';

class MockNFCService extends NFCService {
  final _uuid = const Uuid();
  StreamController<NFCTag>? _tagStreamController;

  @override
  Future<bool> checkAvailability() async {
    return true;
  }

  @override
  Stream<NFCTag> startSession() {
    if (_tagStreamController != null) {
      _tagStreamController!.close();
    }

    _tagStreamController = StreamController<NFCTag>.broadcast();

    Future.delayed(const Duration(seconds: 2), () {
      if (_tagStreamController?.isClosed == false) {
        _tagStreamController?.add(_generateMockTag());
      }
    });

    return _tagStreamController!.stream;
  }

  @override
  Future<void> stopSession() async {
    await _tagStreamController?.close();
    _tagStreamController = null;
  }

  @override
  Future<bool> writeNdefMessage({required List<NFCRecord> records}) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  NFCTag _generateMockTag() {
    final tagType = _getRandomTagType();
    final records = <NFCRecord>[];

    switch (tagType) {
      case NFCRecordType.text:
        records.add(NFCRecord(
          id: _uuid.v4(),
          type: NFCRecordType.text,
          payload: 'This is a sample text from an NFC tag',
          timestamp: DateTime.now(),
        ));
        break;
      case NFCRecordType.url:
        records.add(NFCRecord(
          id: _uuid.v4(),
          type: NFCRecordType.url,
          payload: 'https://example.com',
          timestamp: DateTime.now(),
        ));
        break;
      case NFCRecordType.vCard:
        records.add(NFCRecord(
          id: _uuid.v4(),
          type: NFCRecordType.vCard,
          payload: 'BEGIN:VCARD\nVERSION:3.0\nFN:John Doe\nEMAIL:john@example.com\nTEL:+1234567890\nEND:VCARD',
          timestamp: DateTime.now(),
        ));
        break;
      default:
        records.add(NFCRecord(
          id: _uuid.v4(),
          type: NFCRecordType.text,
          payload: 'Default mock tag content',
          timestamp: DateTime.now(),
        ));
    }

    return NFCTag(
      id: _generateMockTagId(),
      technology: _getRandomTechnology(),
      maxSize: 1024,
      isWritable: true,
      records: records,
      scannedAt: DateTime.now(),
    );
  }

  String _generateMockTagId() {
    return List.generate(5, (_) => _getRandomHexByte()).join(':');
  }

  String _getRandomHexByte() {
    return (List.generate(2, (_) => '0123456789ABCDEF'[DateTime.now().microsecond % 16])
        .join('')
        .toUpperCase());
  }

  NFCRecordType _getRandomTagType() {
    final types = [
      NFCRecordType.text,
      NFCRecordType.url,
      NFCRecordType.vCard,
    ];
    return types[DateTime.now().second % types.length];
  }

  String _getRandomTechnology() {
    final technologies = ['NDEF', 'MIFARE', 'ISO-DEP'];
    return technologies[DateTime.now().second % technologies.length];
  }
}
