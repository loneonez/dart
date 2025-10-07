import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CalendarPage());
  }
}

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('My Calendar'), backgroundColor: Colors.black),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 1週間7日
        ),
        itemCount: 30, // 例として30日
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(2),
            color: Colors.grey[900],
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
