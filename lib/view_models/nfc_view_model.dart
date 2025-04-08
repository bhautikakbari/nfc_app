import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/models/nfc_record.dart';
import 'package:nfc_app/repositories/nfc_repository.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_strings.dart';

enum NFCSessionStatus {
  inactive,
  scanning,
  writing,
}

class NFCViewModel extends ChangeNotifier {
  final NFCRepository repository;
  final _uuid = const Uuid();

  NFCSessionStatus _sessionStatus = NFCSessionStatus.inactive;
  bool _isNfcAvailable = false;
  NFCTag? _lastScannedTag;
  List<NFCTag> _scannedTags = [];
  List<NFCTag> _favoriteTags = [];
  StreamSubscription<NFCTag>? _tagSubscription;
  String? _errorMessage;

  NFCViewModel({required this.repository}) {
    _initialize();
  }

  NFCSessionStatus get sessionStatus => _sessionStatus;
  bool get isNfcAvailable => _isNfcAvailable;
  NFCTag? get lastScannedTag => _lastScannedTag;
  List<NFCTag> get scannedTags => _scannedTags;
  List<NFCTag> get favoriteTags => _favoriteTags;
  String? get errorMessage => _errorMessage;
  bool get isScanning => _sessionStatus == NFCSessionStatus.scanning;
  bool get isWriting => _sessionStatus == NFCSessionStatus.writing;

  NFCRepository get nfcRepository => repository;

  Future<void> _initialize() async {
    _isNfcAvailable = await repository.isNfcAvailable();
    await repository.initialize();
    _refreshTagLists();
    notifyListeners();
  }

  void _refreshTagLists() {
    _scannedTags = repository.getScannedTags();
    _favoriteTags = repository.getFavoriteTags();
  }

  Future<void> startScan() async {
    if (_sessionStatus != NFCSessionStatus.inactive) {
      return;
    }

    _errorMessage = null;
    _sessionStatus = NFCSessionStatus.scanning;
    notifyListeners();

    try {
      final tagStream = repository.startNfcSession();
      _tagSubscription = tagStream.listen(
            (tag) async {
          _lastScannedTag = tag;
          await repository.addScannedTag(tag);
          _refreshTagLists();
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = 'Error scanning tag: $error';
          stopSession();
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to start NFC scan: $e';
      stopSession();
    }
  }

  Future<void> startWrite(List<NFCRecord> records) async {
    if (_sessionStatus != NFCSessionStatus.inactive) {
      return;
    }

    _errorMessage = null;
    _sessionStatus = NFCSessionStatus.writing;
    notifyListeners();

    try {
      final success = await repository.writeNfcTag(records);
      if (!success!) {
        _errorMessage = AppStrings.writeFailed;
      }
    } catch (e) {
      _errorMessage = '${AppStrings.writeFailed}: $e';
    } finally {
      stopSession();
    }
  }

  Future<void> stopSession() async {
    await _tagSubscription?.cancel();
    _tagSubscription = null;
    await repository.stopNfcSession();
    _sessionStatus = NFCSessionStatus.inactive;
    notifyListeners();
  }

  Future<void> toggleFavorite(NFCTag tag) async {
    await repository.toggleFavoriteTag(tag);
    _refreshTagLists();
    notifyListeners();
  }

  bool isTagFavorite(String tagId) {
    return repository.isTagFavorite(tagId);
  }

  Future<void> clearHistory() async {
    await repository.clearHistory();
    _refreshTagLists();
    notifyListeners();
  }

  NFCRecord createTextRecord(String text) {
    return NFCRecord(
      id: _uuid.v4(),
      type: NFCRecordType.text,
      payload: text,
      timestamp: DateTime.now(),
    );
  }

  NFCRecord createUrlRecord(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    return NFCRecord(
      id: _uuid.v4(),
      type: NFCRecordType.url,
      payload: url,
      timestamp: DateTime.now(),
    );
  }

  NFCRecord createVCardRecord({
    required String name,
    String? email,
    String? phone,
    String? organization,
    String? title,
  }) {
    final vCardBuilder = StringBuffer();
    vCardBuilder.writeln('BEGIN:VCARD');
    vCardBuilder.writeln('VERSION:3.0');
    vCardBuilder.writeln('FN:$name');
    if (email != null && email.isNotEmpty) {
      vCardBuilder.writeln('EMAIL:$email');
    }
    if (phone != null && phone.isNotEmpty) {
      vCardBuilder.writeln('TEL:$phone');
    }
    if (organization != null && organization.isNotEmpty) {
      vCardBuilder.writeln('ORG:$organization');
    }
    if (title != null && title.isNotEmpty) {
      vCardBuilder.writeln('TITLE:$title');
    }
    vCardBuilder.writeln('END:VCARD');

    return NFCRecord(
      id: _uuid.v4(),
      type: NFCRecordType.vCard,
      payload: vCardBuilder.toString(),
      timestamp: DateTime.now(),
    );
  }

  Future<void> loadSampleData() async {
    await repository.loadSampleData();
    _refreshTagLists();
    notifyListeners();
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    super.dispose();
  }
}
