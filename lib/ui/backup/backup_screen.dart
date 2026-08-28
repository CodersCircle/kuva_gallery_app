import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';
import '../../domain/models/upload_queue_item.dart';
import '../../providers/app_providers.dart';

/// Backup progress screen showing upload queue status.
class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(uploadQueueProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Backup'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/cloud-settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () =>
                        ref.read(uploadQueueProvider.notifier).processQueue(),
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Start backup'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: queue.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_outlined,
                          size: 48,
                          color: KuvaColors.primaryViolet.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No uploads in queue',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: queue.length,
                    itemBuilder: (context, index) {
                      final item = queue[index];
                      return _UploadTile(item: item);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.item});

  final UploadQueueItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _statusIcon(item.status),
      title: Text(item.fileName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.progress,
              backgroundColor: KuvaColors.accentMint.withValues(alpha: 0.2),
              color: KuvaColors.accentMint,
              minHeight: 4,
            ),
          ),
          if (item.errorMessage != null)
            Text(
              item.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
      trailing: Text(item.status.name),
    );
  }

  Widget _statusIcon(UploadStatus status) {
    switch (status) {
      case UploadStatus.queued:
        return Icon(Icons.schedule, color: KuvaColors.primaryViolet);
      case UploadStatus.uploading:
        return Icon(Icons.cloud_upload, color: KuvaColors.accentMint);
      case UploadStatus.done:
        return const Icon(Icons.check_circle, color: KuvaColors.accentMint);
      case UploadStatus.failed:
        return const Icon(Icons.error, color: Colors.red);
      case UploadStatus.cancelled:
        return const Icon(Icons.cancel);
    }
  }
}
