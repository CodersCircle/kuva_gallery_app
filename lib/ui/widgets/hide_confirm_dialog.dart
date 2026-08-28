import 'package:flutter/material.dart';

/// In-app confirmation before hide — never says "Delete".
Future<bool> confirmHideAlbum(BuildContext context, {String? albumName}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Hide ${albumName ?? 'this album'}?'),
      content: const Text(
        'A secure encrypted copy goes to Vault and the album is hidden in Kuva. '
        'Your originals stay on the device — nothing is deleted.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Hide'),
        ),
      ],
    ),
  ).then((v) => v ?? false);
}

Future<bool> confirmHideItem(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Hide this item?'),
      content: const Text(
        'A secure encrypted copy goes to Vault. '
        'Your original stays on the device — nothing is deleted. '
        'Unhide anytime from Vault.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Hide'),
        ),
      ],
    ),
  ).then((v) => v ?? false);
}
