/// App-wide constants for Kuva Gallery.
class AppConstants {
  AppConstants._();

  static const String appName = 'Kuva Gallery';
  static const String vaultDirName = 'vault';

  // SharedPreferences keys
  static const String prefAppLockEnabled = 'app_lock_enabled';
  static const String prefAlbumGridColumns = 'album_grid_columns';
  static const String prefThemeMode = 'theme_mode';
  static const String prefDataSaver = 'data_saver';
  static const String prefWifiOnlyBackup = 'wifi_only_backup';
  static const String prefBackupVault = 'backup_vault';
  static const String prefLockTimeoutMinutes = 'lock_timeout_minutes';
  static const String prefBiometricEnabled = 'biometric_enabled';
  static const String prefMergeAllAlbums = 'merge_all_albums';
  static const String prefLastSyncTime = 'last_sync_time';
  static const String prefAlbumSortMode = 'album_sort_mode';
  static const String prefAutoPlayNextVideo = 'auto_play_next_video';
  static const String prefHiddenAlbumIds = 'hidden_album_ids';
  static const String prefPinSchemaVersion = 'pin_schema_version';
  static const String prefForcePinReset = 'force_pin_reset';

  // Secure storage keys
  static const String securePinHash = 'pin_hash';
  static const String securePinSalt = 'pin_salt';
  static const String secureEncryptionSalt = 'encryption_salt';
  static const String securePinSet = 'pin_set';

  // Grid limits (home is fixed at 3 columns)
  static const int homeGridColumns = 3;
  static const int albumGridMin = 2;
  static const int albumGridMax = 10;

  // PIN — fixed 4-digit format (schema v2)
  static const int pinLength = 4;
  static const int pinMinLength = 4;
  static const int pinMaxLength = 4;
  static const int currentPinSchemaVersion = 2;

  // Upload queue
  static const int maxUploadRetries = 5;
  static const String uploadTaskName = 'kuvaUploadTask';
  static const String uploadTaskTag = 'kuva_upload_queue';

  // Page size for paged asset loading
  static const int assetPageSize = 80;
}
