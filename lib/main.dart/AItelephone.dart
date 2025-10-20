import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Telephone',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // 最初はキーパッド表示にしてる

  final List<Widget> _pages = [
    const Center(child: Text("よく使う連絡先")),
    const KeypadScreen(), // ← キーパッド画面をここに
    const Center(child: Text("留守番")),
    const Center(child: Text("設定")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "よく使う"),
          BottomNavigationBarItem(icon: Icon(Icons.dialpad), label: "キーパッド"),
          BottomNavigationBarItem(icon: Icon(Icons.voicemail), label: "留守番"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "設定"),
        ],
      ),
    );
  }
}

// =============================
// 🔢 キーパッド画面
// =============================
class KeypadScreen extends StatefulWidget {
  const KeypadScreen({super.key});

  @override
  State<KeypadScreen> createState() => _KeypadScreenState();
}

class _KeypadScreenState extends State<KeypadScreen> {
  String _inputNumber = '';

  void _addNumber(String number) {
    setState(() {
      _inputNumber += number;
    });
  }

  void _deleteNumber() {
    setState(() {
      if (_inputNumber.isNotEmpty) {
        _inputNumber = _inputNumber.substring(0, _inputNumber.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 入力番号表示
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                _inputNumber.isEmpty ? '番号を入力してください' : _inputNumber,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // キーパッド
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.all(20),
                children: [
                  for (var i = 1; i <= 9; i++) _buildKeyButton(i.toString()),
                  _buildKeyButton('*'),
                  _buildKeyButton('0'),
                  _buildKeyButton('#'),
                ],
              ),
            ),

            // 下部ボタン（削除・発信）
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _deleteNumber,
                    icon: const Icon(Icons.backspace, size: 20),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      // 通話開始処理（仮）
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('発信中：$_inputNumber')),
                      );
                    },
                    child: const Icon(Icons.phone, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyButton(String number) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      onPressed: () => _addNumber(number),
      child: Text(
        number,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
