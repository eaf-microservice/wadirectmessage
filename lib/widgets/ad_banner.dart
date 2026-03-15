import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isConnected = false;
  AdSize? _adSize;

  final String _adUnitId = 'ca-app-pub-5890832306883406/4548122505';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool hasConnection =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
      if (hasConnection != _isConnected) {
        setState(() {
          _isConnected = hasConnection;
        });
        if (_isConnected && !_isLoaded) {
          _loadAd();
        }
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    bool hasConnection =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
    if (mounted) {
      setState(() {
        _isConnected = hasConnection;
      });
      if (_isConnected) {
        _loadAd();
      }
    }
  }

  Future<void> _loadAd() async {
    // Use adaptive banner size based on current screen width
    final width = MediaQuery.of(context).size.width.truncate();
    AdSize adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width) ??
        AdSize.banner;

    if (!mounted) return;

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _adSize = adSize;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('AdBanner failed to load: $err');
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _isLoaded = false;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected && _isLoaded && _bannerAd != null && _adSize != null) {
      return SafeArea(
        child: SizedBox(
          width: _adSize!.width.toDouble(),
          height: _adSize!.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
