
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  bool _shouldSendMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Me'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Send a message'),
              value: _shouldSendMessage,
              onChanged: (bool? value) {
                setState(() {
                  _shouldSendMessage = value ?? false;
                });
              },
            ),
            if (_shouldSendMessage)
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openWhatsApp,
              child: const Text('Open WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }

  void _openWhatsApp() async {
    final phone = _phoneController.text;
    final message = _messageController.text;
    final url = _shouldSendMessage
        ? 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}'
        : 'https://wa.me/$phone';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch WhatsApp'),
        ),
      );
    }
  }
}
