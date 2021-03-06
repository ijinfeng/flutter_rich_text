import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rich_text/core/rich_label.dart';
import 'package:rich_text/core/rich_text_define.dart';
import 'package:rich_text/rich_test_route.dart';

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

  Widget createRichLabelDemo() {
    Widget label = RichLabel(
        maxLines: fold ? 2 : 0,
        overflowSpan: TextSpan(
            text: '????????????',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print('??????????????????');
                setState(() {
                  fold = !fold;
                });
              },
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            )),
        overflow: RichTextOverflow.custom,
        text: TextSpan(
            text: '#????????????#',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print("????????????");
              },
            style: const TextStyle(color: Colors.redAccent),
            children: [
              TextSpan(
                  text: '???????????????+??????123456+??????kuhasfjkg??????????????????????????????===',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('??????111');
                    },
                  style: const TextStyle(
                      fontSize: 40,
                      color: Colors.black26,
                      backgroundColor: Colors.lightBlue)),
              const TextSpan(
                  text: '???????????????+??????123456+??????kuhasfjkg??????????????????????????????',
                  style: TextStyle(fontSize: 20, color: Colors.red)),
            ]));
    return label;
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
            Row(
              children: [
                Container(
                  color: Colors.black,
                  child: const Text('H', style: TextStyle(
                    // height: 1.0,
                    fontSize: 40,
                    color: Colors.white,
                    // backgroundColor: Colors.black      
                  ),
                  // strutStyle: StrutStyle(
                  //   leading: 0,
                  //   height: 1.0
                  // ),
                  ),
                ),
                Container(
                  color: Colors.blueAccent,
                  width: 30,
                  height: 40,
                )
              ],
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
                text: TextSpan(children: [
                  TextSpan(
                      text: '??????????????????',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('????????????1267++++++');
                        },
                      style: TextStyle(
                        // height: 1,
                        fontSize: 20,
                        color: Colors.black26,
                      )),
                  TextSpan(
                      text: '??????????????????abcgfh??????123???????????????,.!',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('????????????1267++++++');
                        },
                      style: TextStyle(
                          // height: 1,
                          fontSize: 40,
                          color: Colors.black26,
                          backgroundColor: Colors.lightBlue)),
                  TextSpan(
                      text:
                          '??????????????????????????????123124nkasf???????????????????????????????????????????????????123124nkasf?????????',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          backgroundColor: Colors.blueAccent)),
                  TextSpan(
                      text: '1231a\n41234?????????????????????khsafkh',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('????????????-------');
                        },
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.redAccent,
                          backgroundColor: Colors.black38))
                ])),
            Container(
              color: Colors.green,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: createRichLabelDemo(),
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
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return RichTestRoute();
              })
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
