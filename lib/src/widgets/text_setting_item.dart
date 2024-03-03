import 'package:flutter/material.dart';

class TextSettingItemWidget extends StatefulWidget {
  final String title;
  final String? value;
  final bool isEncrypted;

  const TextSettingItemWidget({super.key, required this.title, this.value, required this.isEncrypted});

  @override
  TextSettingItemWidgetState createState() => TextSettingItemWidgetState();
}

class TextSettingItemWidgetState extends State<TextSettingItemWidget> {
  late TextEditingController _controller;
  late bool _isEncrypted;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _isEncrypted = widget.isEncrypted;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.title),
          trailing: Switch(
              value: _isEncrypted,
              onChanged: _isEncrypted ? null : (bool value) {
              setState(() {
                  _isEncrypted = value;
                });
              },
              activeColor: Colors.blue, // トグルがONの時の色
              inactiveThumbColor: _isEncrypted ? Colors.grey : Colors.red, // トグルがOFFの時の色、無効状態であればグレー
              inactiveTrackColor: _isEncrypted ? Colors.grey[300] : Colors.red[200], // トラックの色も同様に
          ),
          subtitle: TextField(
            controller: _controller,
            onChanged: (newValue) {
              if (_isEncrypted) {
                // newValueを暗号化して表示・保存するロジックをここに実装
              } else {
                // 暗号化せずに保存するロジックをここに実装
              }
            },
            obscureText: _isEncrypted, // パスワードのような値を隠す場合に有効
          ),
        ),
      ],
    );
  }
}