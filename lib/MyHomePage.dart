import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'StartPage.dart';

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
          title: Center(
            child: Text(widget.title),
          ),
        ),
        body: Column(children: <Widget>[
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                child: const Image(
                  width: 320,
                  height: 300,
                  image: NetworkImage(
                      'https://www.stockhype.ch/wp-content/uploads/2020/06/push_ups_1.jpg'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(25),
                width: 130,
                height: 60,
                child: FlatButton(
                  child: Text(
                    'START',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Colors.purple.shade200,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () async {
                    await availableCameras().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartPage(
                            cameras: value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(25),
                width: 130,
                height: 60,
                child: FlatButton(
                  child: Text(
                    'INFO',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Colors.purple.shade200,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Push-up Counter',
                      applicationVersion: '0.0.1',
                      // applicationIcon: const Icon(Icons.info),
                      applicationLegalese: '© Ivana Cetina | 2022',
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 36.0),
                          child: const Text(
                            "To use this app, place the phone under your chest and press the start button.\n",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ]));
  }
}
