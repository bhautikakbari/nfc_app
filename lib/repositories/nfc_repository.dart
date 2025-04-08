import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/models/nfc_record.dart';
import 'package:uuid/uuid.dart';

import '../services/nfc_service.dart';

class NFCRepository {
  final NFCService nfcService;
  final List<NFCTag> _scannedTags = [];
  final List<NFCTag> _favoriteTags = [];

  NFCRepository({required this.nfcService});

  Future<void> initialize() async {
    await _loadSavedTags();
  }

  Future<bool> isNfcAvailable() async {
    return await nfcService.checkAvailability();
  }

  Stream<NFCTag> startNfcSession() {
    return nfcService.startSession();
  }

  Future<void> stopNfcSession() async {
    await nfcService.stopSession();
  }

  Future<bool> writeNfcTag(List<NFCRecord> records) async {
    return await nfcService.writeNdefMessage(records: records);
  }

  List<NFCTag> getScannedTags() {
    return List.unmodifiable(_scannedTags);
  }

  List<NFCTag> getFavoriteTags() {
    return List.unmodifiable(_favoriteTags);
  }

  Future<void> addScannedTag(NFCTag tag) async {
    // Check if tag already exists
    final existingIndex = _scannedTags.indexWhere((t) => t.id == tag.id);
    if (existingIndex >= 0) {
      _scannedTags[existingIndex] = tag;
    } else {
      _scannedTags.add(tag);
    }

    await _saveTags();
  }

  Future<void> toggleFavoriteTag(NFCTag tag) async {
    final existingIndex = _favoriteTags.indexWhere((t) => t.id == tag.id);
    if (existingIndex >= 0) {
      _favoriteTags.removeAt(existingIndex);
    } else {
      _favoriteTags.add(tag);
    }

    await _saveTags();
  }

  bool isTagFavorite(String tagId) {
    return _favoriteTags.any((tag) => tag.id == tagId);
  }

  Future<void> clearHistory() async {
    _scannedTags.clear();
    await _saveTags();
  }

  Future<void> _saveTags() async {
    final prefs = await SharedPreferences.getInstance();

    final scannedTagsJson = _scannedTags
        .map((tag) => jsonEncode(tag.toMap()))
        .toList();

    final favoriteTagsJson = _favoriteTags
        .map((tag) => jsonEncode(tag.toMap()))
        .toList();

    await prefs.setStringList('scanned_tags', scannedTagsJson);
    await prefs.setStringList('favorite_tags', favoriteTagsJson);
  }

  Future<void> _loadSavedTags() async {
    final prefs = await SharedPreferences.getInstance();

    final scannedTagsJson = prefs.getStringList('scanned_tags') ?? [];
    final favoriteTagsJson = prefs.getStringList('favorite_tags') ?? [];

    _scannedTags.clear();
    _scannedTags.addAll(
      scannedTagsJson
          .map((tagJson) => NFCTag.fromMap(jsonDecode(tagJson)))
          .toList(),
    );

    _favoriteTags.clear();
    _favoriteTags.addAll(
      favoriteTagsJson
          .map((tagJson) => NFCTag.fromMap(jsonDecode(tagJson)))
          .toList(),
    );
  }

  // Method to load sample data for testing
  Future<void> loadSampleData() async {
    final uuid = const Uuid();

    // Sample text tag
    final textTag = NFCTag(
      id: '04:A2:F3:91:EF',
      technology: 'NDEF',
      maxSize: 1024,
      isWritable: true,
      records: [
        NFCRecord(
          id: uuid.v4(),
          type: NFCRecordType.text,
          payload: 'This is a sample text from an NFC tag',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
      scannedAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    // Sample URL tag
    final urlTag = NFCTag(
      id: 'A1:B2:C3:D4:E5',
      technology: 'MIFARE',
      maxSize: 2048,
      isWritable: true,
      records: [
        NFCRecord(
          id: uuid.v4(),
          type: NFCRecordType.url,
          payload: 'https://flutter.dev',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      scannedAt: DateTime.now().subtract(const Duration(days: 1)),
    );

    // Sample contact tag
    final contactTag = NFCTag(
      id: 'F1:E2:D3:C4:B5',
      technology: 'ISO-DEP',
      maxSize: 4096,
      isWritable: false,
      records: [
        NFCRecord(
          id: uuid.v4(),
          type: NFCRecordType.vCard,
          payload: 'BEGIN:VCARD\nVERSION:3.0\nFN:Flutter Developer\nEMAIL:dev@flutter.dev\nTEL:+1234567890\nEND:VCARD',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
      scannedAt: DateTime.now().subtract(const Duration(days: 3)),
    );

    // Add tags to history
    await addScannedTag(textTag);
    await addScannedTag(urlTag);
    await addScannedTag(contactTag);

    // Add some favorites
    await toggleFavoriteTag(urlTag);
    await toggleFavoriteTag(contactTag);
  }
}
