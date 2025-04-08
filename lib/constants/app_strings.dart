class AppStrings {
  // App name
  static const String appName = 'NFC Scanner';

  // Navigation
  static const String scanTab = 'Scan';
  static const String writeTab = 'Write';
  static const String historyTab = 'History';
  static const String settingsTab = 'Settings';

  // Scan screen
  static const String scanTitle = 'NFC Scanner';
  static const String startScan = 'Start Scan';
  static const String stopScan = 'Stop Scanning';
  static const String noTagScanned = 'No NFC Tag Scanned';
  static const String tapToScan = 'Tap the scan button to start scanning';
  static const String scanningForTags = 'Scanning for NFC Tags';
  static const String holdNearTag = 'Hold your device near an NFC tag';

  // Write screen
  static const String writeTitle = 'Write NFC Tag';
  static const String writeToTag = 'Write to Tag';
  static const String cancel = 'Cancel';
  static const String textTab = 'Text';
  static const String urlTab = 'URL';
  static const String contactTab = 'Contact';
  static const String writeText = 'Write Text to NFC Tag';
  static const String writeUrl = 'Write URL to NFC Tag';
  static const String writeContact = 'Write Contact to NFC Tag';
  static const String textContent = 'Text Content';
  static const String enterText = 'Enter text to write to the tag';
  static const String urlContent = 'URL';
  static const String enterUrl = 'https://example.com';
  static const String nameField = 'Name';
  static const String emailField = 'Email';
  static const String phoneField = 'Phone';
  static const String readyToWrite = 'Ready to Write';
  static const String pleaseEnterText = 'Please enter some text';
  static const String pleaseEnterUrl = 'Please enter a URL';
  static const String pleaseEnterName = 'Please enter a name';

  // History screen
  static const String historyTitle = 'History';
  static const String scannedTab = 'Scanned';
  static const String favoritesTab = 'Favorites';
  static const String clearHistory = 'Clear History';
  static const String noScanHistory = 'No Scan History';
  static const String scannedTagsAppearHere = 'Scanned tags will appear here';
  static const String noFavorites = 'No Favorites';
  static const String favoriteTagsAppearHere = 'Favorite tags will appear here';
  static const String clearHistoryConfirm = 'Are you sure you want to clear your scan history? This action cannot be undone.';
  static const String clear = 'Clear';

  // Tag details
  static const String tagDetails = 'Tag Details';
  static const String tagInformation = 'Tag Information';
  static const String records = 'Records';
  static const String actions = 'Actions';
  static const String id = 'ID';
  static const String technology = 'Technology';
  static const String capacity = 'Capacity';
  static const String writable = 'Writable';
  static const String scanned = 'Scanned';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String bytes = 'bytes';
  static const String openUrl = 'Open URL';
  static const String addContact = 'Add Contact';
  static const String copy = 'Copy';
  static const String share = 'Share';
  static const String favorite = 'Favorite';

  // Settings screen
  static const String settingsTitle = 'Settings';
  static const String appearance = 'Appearance';
  static const String darkMode = 'Dark Mode';
  static const String enableDarkTheme = 'Enable dark theme';
  static const String nfcSettings = 'NFC Settings';
  static const String saveHistory = 'Save History';
  static const String saveHistoryDesc = 'Save scanned NFC tags to history';
  static const String autoOpenUrls = 'Auto-open URLs';
  static const String autoOpenUrlsDesc = 'Automatically open URLs when scanning tags';
  static const String about = 'About';
  static const String version = 'Version';
  static const String sourceCode = 'Source Code';
  static const String viewOnGithub = 'View on GitHub';
  static const String privacyPolicy = 'Privacy Policy';
  static const String debugTools = 'Debug Tools';
  static const String debugToolsDesc = 'Simulate NFC tags and test scenarios';

  // Debug screen
  static const String debugTitle = 'Debug Tools';
  static const String simulateNfcTags = 'Simulate NFC Tags';
  static const String textTag = 'Text Tag';
  static const String urlTag = 'URL Tag';
  static const String contactTag = 'Contact Tag';
  static const String emptyTag = 'Empty Tag';
  static const String testScenarios = 'Test Scenarios';
  static const String testWriteSuccess = 'Test Write Success';
  static const String testWriteFailure = 'Test Write Failure';

  // Error messages
  static const String nfcNotAvailable = 'NFC Not Available';
  static const String nfcNotAvailableDesc = 'NFC is not available on this device or is disabled. Some features may not work properly.';
  static const String errorOpeningUrl = 'Error opening URL';
  static const String writeSuccessful = 'Write successful!';
  static const String writeFailed = 'Write failed';
  static const String tagNotWritable = 'Tag is not writable';
  static const String contentCopied = 'Content copied to clipboard';
  static const String sharingNotImplemented = 'Sharing functionality would be implemented here';
  static const String contactWouldBeAdded = 'Contact would be added to your device';
  static const String themeSettingsWouldBeSaved = 'Theme settings would be saved in a real app';

  // Tag types
  static const String text = 'Text';
  static const String url = 'URL';
  static const String contact = 'Contact';
  static const String customData = 'Custom Data';
  static const String unknown = 'Unknown';

  // Time formats
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String daysAgo = 'days ago';
}
