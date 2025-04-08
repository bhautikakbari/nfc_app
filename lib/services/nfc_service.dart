import 'dart:async';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/models/nfc_record.dart';

class NFCService {
  final _uuid = const Uuid();
  bool _isAvailable = false;
  StreamController<NFCTag>? _tagStreamController;

  Future<bool> checkAvailability() async {
    try {
      _isAvailable = await NfcManager.instance.isAvailable();
      return _isAvailable;
    } catch (e) {
      return false;
    }
  }

  Stream<NFCTag> startSession() {
    if (_tagStreamController != null) {
      _tagStreamController!.close();
    }

    _tagStreamController = StreamController<NFCTag>.broadcast();

    if (_isAvailable) {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          final nfcTag = _convertNfcTag(tag);
          _tagStreamController?.add(nfcTag);
        },
      );
    }

    return _tagStreamController!.stream;
  }

  Future<void> stopSession() async {
    try {
      await NfcManager.instance.stopSession();
    } catch (e) {
      // Handle error
    }

    await _tagStreamController?.close();
    _tagStreamController = null;
  }

  Future<bool> writeNdefMessage({
    required List<NFCRecord> records,
  }) async {
    try {
      bool success = false;

      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          final ndef = Ndef.from(tag);
          if (ndef == null) {
            throw 'Tag is not NDEF compatible';
          }

          if (!ndef.isWritable) {
            throw 'Tag is not writable';
          }

          final message = NdefMessage(records.map(_convertToNdefRecord).toList());
          try {
            await ndef.write(message);
            success = true;
            NfcManager.instance.stopSession(alertMessage: 'Write successful!');
          } catch (e) {
            NfcManager.instance.stopSession(errorMessage: 'Write failed: $e');
            rethrow;
          }
        },
      );

      return success;
    } catch (e) {
      return false;
    }
  }

  NFCTag _convertNfcTag(NfcTag nfcTag) {
    String tagId = '';
    if (nfcTag.data.containsKey('mifare')) {
      final identifierData = nfcTag.data['mifare']['identifier'];
      tagId = identifierData.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
    } else if (nfcTag.data.containsKey('ndef')) {
      final identifierData = nfcTag.data['ndef']['identifier'];
      if (identifierData != null) {
        tagId = identifierData.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
      } else {
        tagId = _uuid.v4();
      }
    } else {
      tagId = _uuid.v4();
    }

    String technology = 'Unknown';
    if (nfcTag.data.containsKey('mifare')) {
      technology = 'MIFARE';
    } else if (nfcTag.data.containsKey('ndef')) {
      technology = 'NDEF';
    } else if (nfcTag.data.containsKey('isoDep')) {
      technology = 'ISO-DEP';
    }

    bool isWritable = false;
    int maxSize = 0;
    if (nfcTag.data.containsKey('ndef')) {
      final ndef = Ndef.from(nfcTag);
      isWritable = ndef?.isWritable ?? false;
      maxSize = ndef?.maxSize ?? 0;
    }

    List<NFCRecord> records = [];
    if (nfcTag.data.containsKey('ndef')) {
      final ndef = Ndef.from(nfcTag);
      if (ndef != null) {
        final message = ndef.cachedMessage;
        if (message != null) {
          records = message.records.map(_convertNdefRecord).toList();
        }
      }
    }

    return NFCTag(
      id: tagId,
      technology: technology,
      maxSize: maxSize,
      isWritable: isWritable,
      records: records,
      scannedAt: DateTime.now(),
    );
  }

  NFCRecord _convertNdefRecord(NdefRecord record) {
    final id = _uuid.v4();

    if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
      if (_listEquals(record.type, Uint8List.fromList([0x54]))) { // Text record
        final languageCodeLength = record.payload[0] & 0x3F;
        final text = String.fromCharCodes(record.payload.sublist(1 + languageCodeLength));
        return NFCRecord(
          id: id,
          type: NFCRecordType.text,
          payload: text,
          timestamp: DateTime.now(),
        );
      } else if (_listEquals(record.type, Uint8List.fromList([0x55]))) { // URI record
        final prefixCode = record.payload[0];
        final prefixes = [
          '', 'http://www.', 'https://www.', 'http://', 'https://',
          'tel:', 'mailto:', 'ftp://anonymous:anonymous@', 'ftp://ftp.',
          'ftps://', 'sftp://', 'smb://', 'nfs://', 'ftp://', 'dav://',
          'news:', 'telnet://', 'imap:', 'rtsp://', 'urn:', 'pop:',
          'sip:', 'sips:', 'tftp:', 'btspp://', 'btl2cap://', 'btgoep://',
          'tcpobex://', 'irdaobex://', 'file://', 'urn:epc:id:', 'urn:epc:tag:',
          'urn:epc:pat:', 'urn:epc:raw:', 'urn:epc:', 'urn:nfc:'
        ];
        final prefix = prefixCode < prefixes.length ? prefixes[prefixCode] : '';
        final uri = prefix + String.fromCharCodes(record.payload.sublist(1));
        return NFCRecord(
          id: id,
          type: NFCRecordType.url,
          payload: uri,
          timestamp: DateTime.now(),
        );
      }
    } else if (record.typeNameFormat == NdefTypeNameFormat.media) {
      if (String.fromCharCodes(record.type) == 'text/x-vCard') {
        return NFCRecord(
          id: id,
          type: NFCRecordType.vCard,
          payload: String.fromCharCodes(record.payload),
          timestamp: DateTime.now(),
        );
      }
    }

    return NFCRecord(
      id: id,
      type: NFCRecordType.unknown,
      payload: String.fromCharCodes(record.payload),
      timestamp: DateTime.now(),
      metadata: {
        'typeNameFormat': record.typeNameFormat.index,
        'type': record.type.map((e) => e).toList(),
      },
    );
  }

  NdefRecord _convertToNdefRecord(NFCRecord record) {
    switch (record.type) {
      case NFCRecordType.text:
        return NdefRecord.createText(record.payload);
      case NFCRecordType.url:
        return NdefRecord.createUri(Uri.parse(record.payload));
      case NFCRecordType.vCard:
        return NdefRecord.createMime(
          'text/x-vCard',
          Uint8List.fromList(record.payload.codeUnits),
        );
      case NFCRecordType.custom:
      case NFCRecordType.unknown:
      default:
        return NdefRecord.createExternal(
          'com.example.nfcapp',
          'custom',
          Uint8List.fromList(record.payload.codeUnits),
        );
    }
  }

  bool _listEquals(Uint8List? a, Uint8List? b) {
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }
}
