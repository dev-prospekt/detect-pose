import 'package:flutter/material.dart';
import 'package:pushups_counter2/Dashboard1.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(25),
                    width: 300,
                    height: 60,
                    child: FlatButton(
                      child: Text(
                        'SQAT WORKOUT',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      color: Colors.purple.shade200,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StartDashboard()),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(25),
                    width: 300,
                    height: 60,
                    child: FlatButton(
                      child: Text(
                        'LIFT ARMS WORKOUT',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      color: Colors.purple.shade200,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
