import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/Profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _cryptoPanicApiKeyController = TextEditingController();
  final _unsplashApiKeyController = TextEditingController();

  String? _cryptoPanicApiKey;
  String? _unsplashApiKey;

  @override
  void dispose() {
    _cryptoPanicApiKeyController.dispose();
    _unsplashApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _cryptoPanicApiKeyController,
                decoration: const InputDecoration(
                  labelText: 'Cryptopanic API Key',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _cryptoPanicApiKey = value.trim();
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _unsplashApiKeyController,
                decoration: const InputDecoration(
                  labelText: 'Unsplash API Key',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _unsplashApiKey = value.trim();
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed:
                    (_cryptoPanicApiKey != null && _unsplashApiKey != null)
                        ? () {
                            // TODO: Save the API keys and navigate back to the previous screen.
                          }
                        : null,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
