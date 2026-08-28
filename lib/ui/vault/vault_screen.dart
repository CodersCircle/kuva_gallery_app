import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utils/file_utils.dart';
import '../../domain/models/hidden_item.dart';
import '../../providers/app_providers.dart';
import '../widgets/shimmer_box.dart';

/// Vault screen — shimmer loading, PIN only when a PIN exists (#5, #6).
class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  List<HiddenItem>? _items;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeGateAndLoad());
  }

  Future<void> _maybeGateAndLoad() async {
    final hasPin = await ref.read(pinServiceProvider).isPinSet();
    if (hasPin && mounted) {
      final ok = await context.push<bool>(
        '/pin-entry',
        extra: {
          'title': 'Unlock Vault',
          'popOnSuccess': true,
        },
      );
      if (ok != true) {
        if (mounted) context.pop();
        return;
      }
    }
    await _load();
  }

  Future<void> _load() async {
    final items = await ref.read(vaultRepositoryProvider).getHiddenItems();
    if (mounted) setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _items == null
          ? ListView.builder(
              itemCount: 8,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(height: 56, child: ShimmerBox()),
              ),
            )
          : _items!.isEmpty
              ? const Center(child: Text('No hidden items'))
              : ListView.builder(
                  itemCount: _items!.length,
                  itemBuilder: (context, index) {
                    final item = _items![index];
                    return _VaultItemTile(
                      item: item,
                      onUnhide: () => _unhide(item),
                      onDelete: () => _delete(item),
                    );
                  },
                ),
    );
  }

  Future<void> _unhide(HiddenItem item) async {
    final pin = await _askPin();
    if (pin == null) return;
    await ref.read(vaultRepositoryProvider).unhideItem(item, pin);
    await _load();
    ref.invalidate(albumsProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item restored to gallery')),
      );
    }
  }

  Future<void> _delete(HiddenItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete permanently?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await ref.read(vaultRepositoryProvider).deleteHiddenItem(item);
    await _load();
  }

  Future<String?> _askPin() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter PIN'),
        content: TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: AppConstants.pinLength,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _VaultItemTile extends StatelessWidget {
  const _VaultItemTile({
    required this.item,
    required this.onUnhide,
    required this.onDelete,
  });

  final HiddenItem item;
  final VoidCallback onUnhide;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.isVideo ? Icons.videocam_outlined : Icons.image_outlined),
      title: Text(
        FileUtils.fileName(item.originalPath),
        style: AppTextStyles.albumName(context),
      ),
      subtitle: Text(
        '${item.albumName} · ${FileUtils.formatBytes(item.originalSize)}',
        style: AppTextStyles.albumMeta(context),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (v) {
          if (v == 'unhide') onUnhide();
          if (v == 'delete') onDelete();
        },
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'unhide', child: Text('Unhide')),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}
