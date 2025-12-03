import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsappme/widgets/about.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _openWhatsApp() async {
    final phone = _phoneController.text;
    final message = _messageController.text;
    final url =
        'https://wa.me/$phone${message.isNotEmpty ? '?text=${Uri.encodeComponent(message)}' : ''}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('لا يمكن فتح واتساب')));
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
                            const AboutMe(
                              applicationName: 'WhatsAppMe',
                              version: '1.0.3',
                              description:
                                  'An app to send WhatsApp messages without saving the contact.',
                              logo: CircleAvatar(
                                radius: 40,
                                backgroundColor: Color(0xFF25D366),
                                child: Icon(
                                  Icons.phone_iphone,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ).showCustomAbout(context);
                          },
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xFF25D366),
                            child: Icon(
                              Icons.phone_iphone,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'إرسال رسالة واتساب',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'أدخل رقم الهاتف مع رمز الدولة للانتقال\nمباشرة إلى محادثة واتساب دون حفظ الرقم',
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
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'مثال: 212645994904',
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
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
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
                          onPressed: _openWhatsApp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'إرسال رسالة واتساب',
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textDirection: TextDirection.rtl,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'المغرب: 212727593647\nمصر: 20123456789\nالأردن: 962791234567',
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
                          'لا يتم حفظ أي أرقام في جهات الاتصال*',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
