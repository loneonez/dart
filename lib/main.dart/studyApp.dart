import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // 棒グラフ描画ライブラリ

// アプリの起動エントリーポイント
void main() {
  runApp(StudyApp());
}

// アプリ全体を定義（StatelessWidget = 状態を持たない）
class StudyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "勉強時間入力アプリ",
      home: StudyInputPage(), // メイン画面へ
    );
  }
}

// メイン画面は「入力・一覧・グラフ」を含むので StatefulWidget
class StudyInputPage extends StatefulWidget {
  @override
  _StudyInputPageState createState() => _StudyInputPageState(); //「=> = return」 と同じ意味
}

class _StudyInputPageState extends State<StudyInputPage> {
  //<>使用でどのクラスにwidgetを割り当てるか指定
  // テキスト入力を扱うコントローラー
  final _subjectController = TextEditingController(); // 科目名入力　（）で「ユーザー入力用の箱を作る」
  final _hoursController = TextEditingController(); // 勉強時間入力

  // 入力された科目データを格納するリスト
  List<StudySubject> subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //scaffold : 足場
      appBar: AppBar(title: Text("勉強時間入力アプリ")), //appBar：ヘッダー
      body: Padding(
        padding: EdgeInsets.all(16), //allで全面指定
        child: Column(
          children: [
            // =====================
            // 入力フォーム部分
            // =====================
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: "科目名"),
            ),
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(labelText: "勉強時間（時間）"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),

            // 追加ボタン（押すとリストに反映）
            ElevatedButton(
              onPressed: () {
                if (_subjectController.text.isEmpty ||
                    _hoursController.text.isEmpty)
                  return;

                setState(() {
                  subjects.add(
                    StudySubject(
                      name: _subjectController.text,
                      color: Colors.blue, // 仮の固定色
                      hours: double.parse(_hoursController.text),
                    ),
                  );

                  // 入力欄をクリア
                  _subjectController.clear();
                  _hoursController.clear();
                });
              },
              child: Text("追加"),
            ),

            SizedBox(height: 10),

            // =====================
            // 科目リスト + グラフ表示部分
            // =====================
            Expanded(
              child: Column(
                children: [
                  // ---- 科目リスト表示 ----
                  Expanded(
                    child: ListView.builder(
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        return ListTile(
                          title: Text(subject.name),
                          subtitle: Text("${subject.hours} 時間"),
                          leading: CircleAvatar(backgroundColor: subject.color),
                        );
                      },
                    ),
                  ),

                  // ---- 棒グラフ表示 ----
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          // 棒グラフの最大Y値を自動で調整（最大値+1）
                          maxY: subjects.isEmpty
                              ? 10
                              : subjects
                                        .map((s) => s.hours)
                                        .reduce((a, b) => a > b ? a : b) +
                                    1,
                          barTouchData: BarTouchData(enabled: true),

                          // 軸タイトル設定
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                      final index = value.toInt();
                                      if (index >= 0 &&
                                          index < subjects.length) {
                                        return Text(subjects[index].name);
                                      }
                                      return Text('');
                                    },
                              ),
                            ),
                          ),

                          // 棒データを作成（科目ごとに1本）
                          barGroups: subjects.asMap().entries.map((entry) {
                            final index = entry.key;
                            final subject = entry.value;
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: subject.hours, // 棒の高さ
                                  color: subject.color, // 棒の色
                                  width: 20,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// データモデル：科目1つ分
// =====================
class StudySubject {
  String name; // 科目名
  Color color; // 棒の色
  double hours; // 勉強時間

  StudySubject({required this.name, required this.color, required this.hours});
}
