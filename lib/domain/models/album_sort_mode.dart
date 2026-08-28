/// Album list sort options (default: A–Z).
enum AlbumSortMode {
  nameAsc,
  nameDesc,
  recentlyUpdated,
  size,
}

extension AlbumSortModeLabel on AlbumSortMode {
  String get label => switch (this) {
        AlbumSortMode.nameAsc => 'Name (A–Z)',
        AlbumSortMode.nameDesc => 'Name (Z–A)',
        AlbumSortMode.recentlyUpdated => 'Recently Updated',
        AlbumSortMode.size => 'Size',
      };
}
