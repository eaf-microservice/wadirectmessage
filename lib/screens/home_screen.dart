import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wadirectmessage/widgets/about.dart';
import 'package:wadirectmessage/widgets/admob_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  String _fullPhoneNumber = '';
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  BannerAd? _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadBottomBannerAd();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
    _bottomBannerAd?.dispose();
    _bottomBannerAd = null;
    super.dispose();
  }

  void _loadBannerAd() {
    if (!AdMobConfig.adsEnabled) return;

    _bannerAd = BannerAd(
      adUnitId: AdMobConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  void _loadBottomBannerAd() {
    if (!AdMobConfig.adsEnabled) return;

    _bottomBannerAd = BannerAd(
      adUnitId: AdMobConfig.bottomBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Bottom banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> _openWhatsApp() async {
    final message = _messageController.text;
    if (_fullPhoneNumber.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء إدخال رقم هاتف صحيح')),
        );
      }
      return;
    }

    final url =
        'https://wa.me/$_fullPhoneNumber${message.isNotEmpty ? '?text=${Uri.encodeComponent(message)}' : ''}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('لا يمكن فتح التطبيق')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6C5CE7), Color(0xFF5856D6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Banner Ad - Only shows when successfully loaded
              // Banner Ad - Using a stable container to prevent tree reconciliation issues
              SizedBox(
                height: _isBannerAdLoaded && _bannerAd != null
                    ? _bannerAd!.size.height.toDouble()
                    : 0,
                child: _isBannerAdLoaded && _bannerAd != null
                    ? AdWidget(
                        key: ValueKey(_bannerAd!.adUnitId),
                        ad: _bannerAd!,
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showAboutMe().showCustomAbout(context);
                                },
                                child: const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Color(0xFF673AB7),
                                  child: Image(
                                    image: AssetImage('assets/app.png'),
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'إرسال رسالة مباشرة',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'أدخل رقم الهاتف مع رمز الدولة للانتقال\nمباشرة إلى تطبيق المراسلة ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 46, 45, 45),
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'رقم الهاتف (مع رمز الدولة)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 10),
                              IntlPhoneField(
                                decoration: InputDecoration(
                                  hintText: 'مثال: 645994904',
                                  hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 119, 119, 119),
                                  ),
                                  hintTextDirection: TextDirection.rtl,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                initialCountryCode: 'MA',
                                onChanged: (phone) {
                                  setState(() {
                                    _fullPhoneNumber = phone.completeNumber;
                                  });
                                },
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'الرسالة (اختياري)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'اكتب رسالتك هنا',
                                  hintTextDirection: TextDirection.rtl,
                                  hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 119, 119, 119),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  if (_fullPhoneNumber.isNotEmpty) {
                                    _openWhatsApp();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'الرجاء إدخال رقم هاتف صحيح',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF673AB7),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'بدء الدردشة',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Column(
                                  children: [
                                    Text(
                                      'أمثلة على تنسيق الأرقام:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'مصر: 20123456789\nالأردن: 962791234567',
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 48, 48, 48),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '*لا يتم حفظ أي أرقام في جهات الاتصال*\nهذا التطبيق أداة مستقلة وليس له علاقة بشركة WhatsApp Inc',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom Banner Ad
              SizedBox(
                height: _isBottomBannerAdLoaded && _bottomBannerAd != null
                    ? _bottomBannerAd!.size.height.toDouble()
                    : 0,
                child: _isBottomBannerAdLoaded && _bottomBannerAd != null
                    ? AdWidget(
                        key: ValueKey('bottom_${_bottomBannerAd!.adUnitId}'),
                        ad: _bottomBannerAd!,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AboutMe _showAboutMe() {
    return const AboutMe(
      applicationName: 'Wa Direct Message',
      version: '1.1.0',
      description:
          'Send direct messages without saving contacts. Fast, secure, and easy to use.',
      logo: CircleAvatar(
        radius: 40,
        backgroundColor: Color(0xFF673AB7),
        child: Image(
          image: AssetImage('assets/app.png'),
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
