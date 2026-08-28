import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/cloud/cloudinary_uploader.dart';
import '../../data/datasources/cloud/google_drive_uploader.dart';
import '../../data/datasources/cloud/s3_uploader.dart';
import '../../domain/models/cloud_target.dart';
import '../../providers/app_providers.dart';

/// Cloud storage connection settings.
class CloudSettingsScreen extends ConsumerStatefulWidget {
  const CloudSettingsScreen({super.key});

  @override
  ConsumerState<CloudSettingsScreen> createState() =>
      _CloudSettingsScreenState();
}

class _CloudSettingsScreenState extends ConsumerState<CloudSettingsScreen> {
  List<CloudTarget> _targets = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final targets = await ref.read(uploadRepositoryProvider).getCloudTargets();
    if (mounted) setState(() => _targets = targets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connected Storage')),
      body: ListView(
        children: [
          _ProviderTile(
            title: 'Google Drive',
            icon: Icons.drive_folder_upload,
            connected: _isConnected(CloudProvider.googleDrive),
            onConnect: _connectGoogleDrive,
          ),
          _ProviderTile(
            title: 'Cloudinary',
            icon: Icons.cloud,
            connected: _isConnected(CloudProvider.cloudinary),
            onConnect: _connectCloudinary,
          ),
          _ProviderTile(
            title: 'Amazon S3 / Compatible',
            icon: Icons.storage,
            connected: _isConnected(CloudProvider.s3),
            onConnect: _connectS3,
          ),
          if (_targets.isNotEmpty) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Saved connections', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ..._targets.map(
              (t) => ListTile(
                title: Text(t.displayName),
                subtitle: Text(t.provider.name),
                trailing: Icon(
                  t.isConnected ? Icons.check_circle : Icons.error,
                  color: t.isConnected ? KuvaColors.accentMint : Colors.grey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isConnected(CloudProvider provider) {
    return _targets.any((t) => t.provider == provider && t.isConnected);
  }

  Future<void> _connectGoogleDrive() async {
    final folderController = TextEditingController();
    final folderId = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Google Drive'),
        content: TextField(
          controller: folderController,
          decoration: const InputDecoration(
            labelText: 'Folder ID (optional)',
            hintText: 'Leave empty for root',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, folderController.text),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
    if (folderId == null) return;

    final uploader = GoogleDriveUploader(folderId: folderId);
    final ok = await uploader.testConnection();

    final target = CloudTarget()
      ..provider = CloudProvider.googleDrive
      ..displayName = 'Google Drive'
      ..isConnected = ok
      ..backupVault = false
      ..configJson = GoogleDriveUploader.configToJson(folderId: folderId);

    await ref.read(uploadRepositoryProvider).saveCloudTarget(target);
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'Connected' : 'Connection failed')),
      );
    }
  }

  Future<void> _connectCloudinary() async {
    final cloudName = TextEditingController();
    final apiKey = TextEditingController();
    final apiSecret = TextEditingController();
    final preset = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cloudinary'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: cloudName, decoration: const InputDecoration(labelText: 'Cloud name')),
              TextField(controller: apiKey, decoration: const InputDecoration(labelText: 'API Key')),
              TextField(controller: apiSecret, decoration: const InputDecoration(labelText: 'API Secret'), obscureText: true),
              TextField(controller: preset, decoration: const InputDecoration(labelText: 'Upload preset (optional)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Connect')),
        ],
      ),
    );
    if (ok != true) return;

    final uploader = CloudinaryUploader(
      cloudName: cloudName.text,
      apiKey: apiKey.text,
      apiSecret: apiSecret.text,
      uploadPreset: preset.text.isEmpty ? null : preset.text,
    );
    final connected = await uploader.testConnection();

    final target = CloudTarget()
      ..provider = CloudProvider.cloudinary
      ..displayName = 'Cloudinary'
      ..isConnected = connected
      ..backupVault = false
      ..configJson = CloudinaryUploader.configToJson(
        cloudName: cloudName.text,
        apiKey: apiKey.text,
        apiSecret: apiSecret.text,
        uploadPreset: preset.text.isEmpty ? null : preset.text,
      );

    await ref.read(uploadRepositoryProvider).saveCloudTarget(target);
    await _load();
  }

  Future<void> _connectS3() async {
    final accessKey = TextEditingController();
    final secretKey = TextEditingController();
    final bucket = TextEditingController();
    final region = TextEditingController();
    final endpoint = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('S3-Compatible Storage'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: accessKey, decoration: const InputDecoration(labelText: 'Access Key')),
              TextField(controller: secretKey, decoration: const InputDecoration(labelText: 'Secret Key'), obscureText: true),
              TextField(controller: bucket, decoration: const InputDecoration(labelText: 'Bucket')),
              TextField(controller: region, decoration: const InputDecoration(labelText: 'Region')),
              TextField(controller: endpoint, decoration: const InputDecoration(labelText: 'Custom endpoint (MinIO/Wasabi)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Connect')),
        ],
      ),
    );
    if (ok != true) return;

    final uploader = S3Uploader(
      accessKey: accessKey.text,
      secretKey: secretKey.text,
      bucket: bucket.text,
      region: region.text,
      endpoint: endpoint.text.isEmpty ? null : endpoint.text,
    );
    final connected = await uploader.testConnection();

    final target = CloudTarget()
      ..provider = CloudProvider.s3
      ..displayName = bucket.text
      ..isConnected = connected
      ..backupVault = false
      ..configJson = S3Uploader.configToJson(
        accessKey: accessKey.text,
        secretKey: secretKey.text,
        bucket: bucket.text,
        region: region.text,
        endpoint: endpoint.text.isEmpty ? null : endpoint.text,
      );

    await ref.read(uploadRepositoryProvider).saveCloudTarget(target);
    await _load();
  }
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({
    required this.title,
    required this.icon,
    required this.connected,
    required this.onConnect,
  });

  final String title;
  final IconData icon;
  final bool connected;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: connected
          ? const Chip(label: Text('Connected'))
          : OutlinedButton(onPressed: onConnect, child: const Text('Connect')),
    );
  }
}
