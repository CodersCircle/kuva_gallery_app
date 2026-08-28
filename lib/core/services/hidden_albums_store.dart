import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Albums hidden in Kuva (vault copy only — originals stay on device).
class HiddenAlbumsStore {
  Future<Set<String>> getHiddenAlbumIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AppConstants.prefHiddenAlbumIds)?.toSet() ?? {};
  }

  Future<void> markAlbumHidden(String albumId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await getHiddenAlbumIds();
    ids.add(albumId);
    await prefs.setStringList(AppConstants.prefHiddenAlbumIds, ids.toList());
  }

  Future<void> unmarkAlbum(String albumId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await getHiddenAlbumIds();
    ids.remove(albumId);
    await prefs.setStringList(AppConstants.prefHiddenAlbumIds, ids.toList());
  }
}
