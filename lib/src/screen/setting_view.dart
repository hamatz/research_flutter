import 'package:flutter/material.dart';
import 'package:chat_sample_app/src/models/settings_model.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final List<SettingItem> settings = [
    UserProfileSettingItem(username: "未登録", imagePath: "path/to/image"),
    TextSettingItem(title: "Azure API Key", value: "Your API Key Here", isEncrypted: true),
    TextSettingItem(title: "Azure OpenAI Base Name", value: "Your API BaseName Here", isEncrypted: true),
    TextSettingItem(title: "Azure OpenAI API Version", value: "Your API version Here", isEncrypted: false),
    TextSettingItem(title: "Azure OpenAI Deployment Name", value: "Your Deployment Name Here", isEncrypted: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return settings[index].buildWidget(context);
        },
      ),
    );
  }
}
