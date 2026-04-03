import 'dart:io';

/// AdMob configuration for managing ad unit IDs across the app
class AdMobConfig {
  // Set to true to use test ads (recommended for development)
  static const bool useTestAds = !bool.fromEnvironment('dart.vm.product');

  // Test Ad Unit IDs (safe to use during development)
  static String get _testBannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // Android test banner
      : 'ca-app-pub-4469172481054302/2934735716'; // iOS test banner

  // Test Ad Unit IDs for Bottom Banner
  static String get _testBottomBannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // Android test banner
      : 'ca-app-pub-4469172481054302/2934735716'; // iOS test banner

  // Production Ad Unit IDs (replace with your actual AdMob ad unit IDs)
  static const String _productionBannerAdUnitIdAndroid =
      // Replace with your Android banner ad unit ID
      'ca-app-pub-5890832306883406/1810783105';
  static const String _productionBannerAdUnitIdIOS =
      // Replace with your iOS banner ad unit ID
      'ca-app-pub-5890832306883406/1810783105';

  // Production Ad Unit IDs for Bottom Banner
  static const String _productionBottomBannerAdUnitIdAndroid =
      // Replace with your Android bottom banner ad unit ID
      'ca-app-pub-5890832306883406/3145953998';
  static const String _productionBottomBannerAdUnitIdIOS =
      // Replace with your iOS bottom banner ad unit ID
      'ca-app-pub-5890832306883406/3145953998';

  /// Get the appropriate banner ad unit ID based on platform and test mode
  static String get bannerAdUnitId {
    if (useTestAds) {
      return _testBannerAdUnitId;
    }

    return Platform.isAndroid
        ? _productionBannerAdUnitIdAndroid
        : _productionBannerAdUnitIdIOS;
  }

  /// Get the appropriate bottom banner ad unit ID based on platform and test mode
  static String get bottomBannerAdUnitId {
    if (useTestAds) {
      return _testBottomBannerAdUnitId;
    }

    return Platform.isAndroid
        ? _productionBottomBannerAdUnitIdAndroid
        : _productionBottomBannerAdUnitIdIOS;
  }

  /// Check if ads are enabled
  static bool get adsEnabled => true; // Set to false to disable all ads

  /// Get banner ad height (standard banner is 50 pixels)
  static const double bannerHeight = 50.0;
}
