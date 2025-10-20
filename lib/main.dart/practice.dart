import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TextPractice());
  }
}

class TextPractice extends StatefulWidget {
  const TextPractice({super.key});

  @override
  State<TextPractice> createState() => _TextPracticeState();
}

class _TextPracticeState extends State<TextPractice> {
  final TextEditingController _controller = TextEditingController();
  String displayText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('テキスト練習')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'ここに入力',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  displayText = text;
                });
              },
            ),
            const SizedBox(height: 20),
            Text('入力内容: $displayText', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
