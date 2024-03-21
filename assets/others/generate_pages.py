import json

# JSONファイルからscreen_name_mappingを読み込む
with open('screen_name_mapping.json', 'r') as file:
    screen_name_mapping = json.load(file)

# Dartファイルのスケルトンを生成
def create_dart_file(filename, classname):
    content = f"""import 'package:flutter/material.dart';

class {classname} extends StatelessWidget {{
  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: Text('{classname}'),
      ),
      body: Center(
        child: Text('Welcome to {classname}'),
      ),
    );
  }}
}}
"""
    with open(filename, 'w') as file:
        file.write(content)
    print(f'Generated {filename} for {classname}')

def main():
    for jp_view, en_view in screen_name_mapping.items():
        filename = f"{en_view}.dart"
        classname = ''.join(word.title() for word in en_view.split('_'))
        create_dart_file(filename, classname)

if __name__ == '__main__':
    main()
