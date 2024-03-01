import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:chat_sample_app/src/chat_service.dart' as cs;

const AZURE_OPENAI_KEY = "Azure OpenAIのアクセストークン";
const AZURE_API_BASE_URL="ベースURL";
const AZURE_API_VERSION="APIバージョン";
const AZURE_DEPLOYMENT_NAME="deployment名";

void main() {
  runApp(MyApp());
  print(azureOpenaiEndpointUrl); // この行をmain関数内
} 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}
String constructAzureOpenAIEndpoint({
  required String endpointBaseUrl,
  required String deploymentName,
  required String apiVersion,
}) {
  final String endpoint = 'https://$endpointBaseUrl.openai.azure.com/openai/deployments/$deploymentName/chat/completions?api-version=$apiVersion';
  return endpoint;
}

final String azureOpenaiEndpointUrl = constructAzureOpenAIEndpoint(
    endpointBaseUrl: AZURE_API_BASE_URL,
    deploymentName: AZURE_DEPLOYMENT_NAME,
    apiVersion: AZURE_API_VERSION,
);

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final cs.ChatService chatService = cs.ChatService(
    endpoint: azureOpenaiEndpointUrl,
    apiKey: AZURE_OPENAI_KEY,
  );

  List<String> messages = [];
  List<String> collectedChunks = []; 
  TextEditingController messageController = TextEditingController();
  String currentResponse = ""; // 現在のAPI応答を保持するための変数

  late final cs.ChatRequest request; 

  @override
  void initState() {
    super.initState();
  }

  void fetchChatResponses(cs.ChatRequest request) async {
    currentResponse = ""; // 新しい応答の取得を開始する前にリセット
    chatService.chat(request).listen((response) {
      if (response['choices'][0]['delta']['content'] != null && response['choices'][0]['delta']['content'].isNotEmpty) {
        setState(() {
          // 既存のメッセージアイテムを更新するか、新しいメッセージアイテムを追加
          if (currentResponse.isEmpty) {
            messages.add(response['choices'][0]['delta']['content']); // 初めてのチャンクの場合、新しいメッセージとして追加
          } else {
            messages[messages.length - 1] = currentResponse + response['choices'][0]['delta']['content']; // 既存のメッセージを更新
          }
          currentResponse += response['choices'][0]['delta']['content']; // 現在の応答にチャンクを追加
        });
      }
    }, onError: (error) {
      print("Error: $error");
      // エラー処理...
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter手習い"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MarkdownBody(
                      data: messages[index],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "メッセージを入力",
              ),
              onChanged: (text) {
                // 入力が始まったら、リアルタイムで表示を更新
                setState(() {
                  if (messages.isEmpty || messages.last != text) {
                    if (messages.isNotEmpty) {
                      messages.removeLast();
                    }
                    messages.add(text);
                  }
                });
              },
              onSubmitted: (text) {
                cs.ChatRequest newRequest = cs.ChatRequest(
                  model: "gpt-4",
                  messages: [cs.ChatMessage(messageType: cs.MessageType.user, content: text)],
                  maxTokens: 500,
                  stream: true,
                );
                fetchChatResponses(newRequest);
                messageController.clear(); // テキストフィールドをクリア
              },
            ),
          ),
        ],
      ),
    );
  }
}
