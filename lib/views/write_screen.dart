import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/view_models/nfc_view_model.dart';
import 'package:nfc_app/models/nfc_record.dart';
import 'package:nfc_app/constants/app_strings.dart';
import 'package:nfc_app/widgets/app_text.dart';
import 'package:nfc_app/widgets/app_button.dart';
import 'package:nfc_app/widgets/app_text_field.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  int _selectedTabIndex = 0;
  NFCViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = Provider.of<NFCViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    // Stop NFC session when leaving the screen
    if (_viewModel != null && _viewModel!.isWriting) {
      _viewModel!.stopSession();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NFCViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const AppText(
              AppStrings.writeTitle,
              type: AppTextType.headline6,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                _buildTabBar(),
                Expanded(
                  child: _buildTabContent(viewModel),
                ),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppText(
                      viewModel.errorMessage!,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildWriteButton(viewModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabButton(AppStrings.textTab, 0),
          _buildTabButton(AppStrings.urlTab, 1),
          _buildTabButton(AppStrings.contactTab, 2),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppText(
            label,
            textAlign: TextAlign.center,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(NFCViewModel viewModel) {
    if (viewModel.isWriting) {
      return _buildWritingView();
    }

    switch (_selectedTabIndex) {
      case 0:
        return _buildTextForm();
      case 1:
        return _buildUrlForm();
      case 2:
        return _buildContactForm();
      default:
        return _buildTextForm();
    }
  }

  Widget _buildTextForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              AppStrings.writeText,
              type: AppTextType.subtitle1,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _textController,
              label: AppStrings.textContent,
              hint: AppStrings.enterText,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.pleaseEnterText;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              AppStrings.writeUrl,
              type: AppTextType.subtitle1,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _urlController,
              label: AppStrings.urlContent,
              hint: AppStrings.enterUrl,
              prefixText: 'https://',
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.pleaseEnterUrl;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                AppStrings.writeContact,
                type: AppTextType.subtitle1,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _nameController,
                label: AppStrings.nameField,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _emailController,
                label: AppStrings.emailField,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _phoneController,
                label: AppStrings.phoneField,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWritingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          const AppText(
            AppStrings.readyToWrite,
            type: AppTextType.headline5,
          ),
          const SizedBox(height: 8),
          AppText(
            AppStrings.holdNearTag,
            type: AppTextType.bodyMedium,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildWriteButton(NFCViewModel viewModel) {
    return AppButton(
      text: viewModel.isWriting ? AppStrings.cancel : AppStrings.writeToTag,
      onPressed: viewModel.isWriting ? viewModel.stopSession : () => _writeTag(viewModel),
      type: AppButtonType.primary,
      fullWidth: true,
      icon: viewModel.isWriting ? Icons.cancel : Icons.edit,
    );
  }

  void _writeTag(NFCViewModel viewModel) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    List<NFCRecord> records = [];

    switch (_selectedTabIndex) {
      case 0:
        records.add(viewModel.createTextRecord(_textController.text));
        break;
      case 1:
        records.add(viewModel.createUrlRecord(_urlController.text));
        break;
      case 2:
        records.add(viewModel.createVCardRecord(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
        ));
        break;
    }

    viewModel.startWrite(records);
  }
}
