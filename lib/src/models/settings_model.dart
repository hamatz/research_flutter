import 'package:flutter/material.dart';
import 'package:chat_sample_app/src/widgets/text_setting_item.dart';

abstract class SettingItem {
  Widget buildWidget(BuildContext context);
}

class UserProfileSettingItem extends SettingItem {
  final String username;
  final String imagePath;

  UserProfileSettingItem({required this.username, required this.imagePath});

  @override
  Widget buildWidget(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imagePath),
      ),
      title: Text(username),
    );
  }
}

class TextSettingItem extends SettingItem {
  final String title;
  final String? value;
  final bool isEncrypted;

  TextSettingItem({required this.title, this.value, required this.isEncrypted});

  @override
  Widget buildWidget(BuildContext context) {
    return TextSettingItemWidget(title: title, value: value, isEncrypted: isEncrypted);
  }
}
