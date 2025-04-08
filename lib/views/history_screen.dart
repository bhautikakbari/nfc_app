import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/view_models/nfc_view_model.dart';
import 'package:nfc_app/models/nfc_tag.dart';
import 'package:nfc_app/widgets/tag_list_item.dart';
import 'package:nfc_app/views/tag_details_screen.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.historyTitle),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: AppStrings.scannedTab),
              Tab(text: AppStrings.favoritesTab),
            ],
          ),
          actions: [
            Consumer<NFCViewModel>(
              builder: (context, viewModel, child) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: viewModel.scannedTags.isEmpty
                      ? null
                      : () => _showClearHistoryDialog(context, viewModel),
                  tooltip: AppStrings.clearHistory,
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildScannedTagsList(),
            _buildFavoritesTagsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildScannedTagsList() {
    return Consumer<NFCViewModel>(
      builder: (context, viewModel, child) {
        final tags = viewModel.scannedTags;

        if (tags.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noScanHistory,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.scannedTagsAppearHere,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: tags.length,
          itemBuilder: (context, index) {
            final tag = tags[tags.length - 1 - index]; // Reverse order (newest first)
            return TagListItem(
              tag: tag,
              isFavorite: viewModel.isTagFavorite(tag.id),
              onToggleFavorite: () => viewModel.toggleFavorite(tag),
              onTap: () => _navigateToTagDetails(context, tag),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoritesTagsList() {
    return Consumer<NFCViewModel>(
      builder: (context, viewModel, child) {
        final tags = viewModel.favoriteTags;

        if (tags.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  size: 64,
                  color: AppColors.favoriteColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noFavorites,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.favoriteTagsAppearHere,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: tags.length,
          itemBuilder: (context, index) {
            final tag = tags[index];
            return TagListItem(
              tag: tag,
              isFavorite: true,
              onToggleFavorite: () => viewModel.toggleFavorite(tag),
              onTap: () => _navigateToTagDetails(context, tag),
            );
          },
        );
      },
    );
  }

  void _navigateToTagDetails(BuildContext context, NFCTag tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TagDetailsScreen(tag: tag),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, NFCViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.clearHistory),
        content: Text(AppStrings.clearHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.clearHistory();
              Navigator.of(context).pop();
            },
            child: Text(
              AppStrings.clear,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
