import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/view_models/nfc_view_model.dart';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/models/nfc_record.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_strings.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.debugTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(context, AppStrings.simulateNfcTags),
          _buildSimulateTagButton(
            context,
            AppStrings.textTag,
            'This is a sample text from an NFC tag',
            NFCRecordType.text,
          ),
          _buildSimulateTagButton(
            context,
            AppStrings.urlTag,
            'https://example.com',
            NFCRecordType.url,
          ),
          _buildSimulateTagButton(
            context,
            AppStrings.contactTag,
            'BEGIN:VCARD\nVERSION:3.0\nFN:John Doe\nEMAIL:john@example.com\nTEL:+1234567890\nEND:VCARD',
            NFCRecordType.vCard,
          ),
          _buildSimulateTagButton(
            context,
            AppStrings.emptyTag,
            '',
            NFCRecordType.unknown,
            hasRecords: false,
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, AppStrings.testScenarios),
          _buildTestButton(
            context,
            AppStrings.testWriteSuccess,
                () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.writeSuccessful)),
              );
            },
          ),
          _buildTestButton(
            context,
            AppStrings.testWriteFailure,
                () {
              final viewModel = Provider.of<NFCViewModel>(context, listen: false);
              viewModel.startWrite([
                NFCRecord(
                  id: const Uuid().v4(),
                  type: NFCRecordType.text,
                  payload: 'Test',
                  timestamp: DateTime.now(),
                )
              ]);

              // Simulate failure after 2 seconds
              Future.delayed(const Duration(seconds: 2), () {
                if (viewModel.isWriting) {
                  viewModel.stopSession();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${AppStrings.writeFailed}: ${AppStrings.tagNotWritable}')),
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSimulateTagButton(
      BuildContext context,
      String label,
      String payload,
      NFCRecordType type, {
        bool hasRecords = true,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(label),
        subtitle: Text(payload.length > 30 ? '${payload.substring(0, 30)}...' : payload),
        trailing: const Icon(Icons.play_arrow),
        onTap: () {
          _simulateTagScan(context, payload, type, hasRecords);
        },
      ),
    );
  }

  Widget _buildTestButton(
      BuildContext context,
      String label,
      VoidCallback onPressed,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(label),
        trailing: const Icon(Icons.play_arrow),
        onTap: onPressed,
      ),
    );
  }

  void _simulateTagScan(
      BuildContext context,
      String payload,
      NFCRecordType type,
      bool hasRecords,
      ) {
    final viewModel = Provider.of<NFCViewModel>(context, listen: false);
    final uuid = const Uuid();

    final records = <NFCRecord>[];
    if (hasRecords) {
      records.add(NFCRecord(
        id: uuid.v4(),
        type: type,
        payload: payload,
        timestamp: DateTime.now(),
      ));
    }

    final tag = NFCTag(
      id: List.generate(5, (_) => List.generate(2, (_) =>
      '0123456789ABCDEF'[DateTime.now().microsecond % 16]).join('')
      ).join(':').toUpperCase(),
      technology: 'NDEF',
      maxSize: 1024,
      isWritable: true,
      records: records,
      scannedAt: DateTime.now(),
    );

    viewModel.startScan();

    // Simulate tag scan after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (viewModel.isScanning) {
        // Access the repository directly to add the tag
        viewModel.nfcRepository.addScannedTag(tag);
        viewModel.stopSession();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Simulated ${type.toString().split('.').last} tag scan')),
        );
      }
    });
  }
}
