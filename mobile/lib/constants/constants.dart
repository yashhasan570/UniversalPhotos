import 'dart:io';

const String kMobileMetadataKey = "mobile-app";

// Number of log entries to retain on app start
const int kLogTruncateLimit = 2000;
// Number of log entries that triggers the trim back to kLogTruncateLimit
const int kLogTruncateThreshold = 3000;

// Sync
const int kSyncEventBatchSize = 5000;

// Hash batch limits
final int kBatchHashFileLimit = Platform.isIOS ? 32 : 512;

// Secure storage keys
const String kSecuredPinCode = "secured_pin_code";

// background_downloader task groups
const String kManualUploadGroup = 'manual_upload_group';
const String kBackupGroup = 'backup_group';
const String kBackupLivePhotoGroup = 'backup_live_photo_group';
const String kDownloadGroupImage = 'group_image';
const String kDownloadGroupVideo = 'group_video';
const String kDownloadGroupLivePhoto = 'group_livephoto';
const String kShareDownloadGroup = 'group_share';

// Timeline constants
const int kTimelineAssetLoadBatchSize = 1024;
const int kTimelineAssetLoadOppositeSize = 64;

// Widget keys
const String kWidgetAuthToken = "widget_auth_token";
const String kWidgetServerEndpoint = "widget_server_url";
const String kWidgetCustomHeaders = "widget_custom_headers";

// add widget identifiers here for new widgets
// these are used to force a widget refresh
// (iOSName, androidFQDN)
const List<(String, String)> kWidgetNames = [
  ('com.universal_photos.widget.random', 'app.alextran.universal_photos.widget.RandomReceiver'),
  ('com.universal_photos.widget.memory', 'app.alextran.universal_photos.widget.MemoryReceiver'),
];

const int kMinMonthsToEnableScrubberSnap = 12;

const String kUniversalPhotosAppStoreLink = "https://apps.apple.com/app/universal_photos/id1613945652";
const String kUniversalPhotosPlayStoreLink = "https://play.google.com/store/apps/details?id=app.alextran.universal_photos";
const String kUniversalPhotosLatestRelease = "https://github.com/yashhasan570/UniversalPhotos/releases/latest";

const int kPhotoTabIndex = 0;
const int kSearchTabIndex = 1;
const int kAlbumTabIndex = 2;
// ignore: unused-code
const int kLibraryTabIndex = 3;

// Workaround for SQLite's variable limit (SQLITE_MAX_VARIABLE_NUMBER = 32766)
const int kDriftMaxChunk = 32000;
