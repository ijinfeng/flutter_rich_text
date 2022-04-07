import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rich_text/core/rich_label.dart';
import 'package:rich_text/core/rich_text_define.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  bool fold = true;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              strutStyle: StrutStyle(
                leading: 0,
                // height: 0,
              ),
              style: TextStyle(
                        fontSize: 30,
                        backgroundColor: Colors.lightGreen,
                        // textBaseline: TextBaseline.ideographic,
                        color: Colors.black),
            ),
            // Container(
            //       color: Colors.blue,
            //       child: new Text(
            //         "Hg",
            //         style: TextStyle(
            //           fontSize: 100,
            //           backgroundColor: Colors.green.withAlpha(180)
            //         ),
            //         strutStyle: StrutStyle(
            //           forceStrutHeight: true,
            //           fontSize: 100,
            //           height: 1,
            //         ),

            //       ),

            //     ),
            RichText(
              maxLines: 2,
                  text: TextSpan(
                      text: '头部',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("点击头部！！");
                        },
                      children: [
                        TextSpan(
                            text: '中文',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('点击中文1267++++++');
                              },
                            style: TextStyle(
                                // height: 1,
                                fontSize: 20,
                                color: Colors.black26,
                                )),
                        TextSpan(
                            text: '中文1267呀中文1267这gn你好',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('点击中文1267++++++');
                              },
                            style: TextStyle(
                                // height: 1,
                                fontSize: 40,
                                color: Colors.black26,
                                backgroundColor: Colors.lightBlue
                                )),
                        TextSpan(
                            text:
                                '我是一只卡号发的快回123124nkasf的快回我是一只卡号发的快回复爱对方123124nkasf的快回',
                            style: TextStyle(fontSize: 20, color: Colors.red, backgroundColor: Colors.blueAccent)),
                        TextSpan(
                            text: '1231a\n41234阿卡戴珊卡话费khsafkh',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('点击数字-------');
                              },
                            style: TextStyle(fontSize: 20, color: Colors.redAccent, backgroundColor: Colors.black38))
                      ])),
            Container(
              color: Colors.green,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichLabel(
                  maxLines: fold ? 2 : 0,
                  overflowSpan: TextSpan(
                      text: '展示全部...',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('点击展开全部');
                          setState(() {
                            fold = !fold;
                          });
                        },
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                  overflow: RichTextOverflow.custom,
                  text: TextSpan(
                      text: '头部2',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("点击头部！！");
                        },
                      children: [
                        TextSpan(
                            text: '中文001267这gn你好n你好呀中文1267这gn你好呀呀中文1267这gn你好呀',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('点击中文1267++++++');
                              },
                            style: TextStyle(
                                // height: 1,
                                fontSize: 40,
                                color: Colors.black26,
                                backgroundColor: Colors.lightBlue
                                )),
                        TextSpan(
                            text:
                                '我是一只卡号发的快回123124nkasf的快回我是一只卡号发的快回复爱对方123124nkasf的快回',
                            style: TextStyle(fontSize: 20, color: Colors.red)),
                        TextSpan(
                            text: '1231a\n41234阿卡戴珊卡话费khsafkh',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('点击数字-------');
                              },
                            style: TextStyle(fontSize: 20, color: Colors.redAccent, backgroundColor: Colors.black38))
                      ])),
            ),
            Container(
              color: Colors.green,
              width: 80,
              height: 80,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
