import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'classes.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(storage: CounterStorage() ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);
  final CounterStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _cnt_shared_pref = 0;
  int _cnt_path_prov   = 0;

  @override
  void initState() {
    super.initState();
    _loadCntSharedPref();
    _loadCntPathProv ();

  }

  void _loadCntSharedPref() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _cnt_shared_pref = (sharedPref.getInt('counter_shared_pref') ?? 0);
    });
  }
  void _loadCntPathProv () {
    widget.storage.readCounter().then((int value) {
      setState(() {
        _cnt_path_prov = value;
      });
    });
  }

  void _incCntSharedPref() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      //_cnt_shared_pref++;
      _cnt_shared_pref = (sharedPref.getInt('counter_shared_pref') ?? 0) + 1;
      sharedPref.setInt('counter_shared_pref', _cnt_shared_pref);
    });
  }

  Future <File> _incCntPathProv() {
    setState(() {
      _cnt_path_prov ++;
    });
    return widget.storage.writeCounter( _cnt_path_prov );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("case 3.1 min"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Counter for shared preferences:',
            ),
            Text(
              '$_cnt_shared_pref',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                onPressed: _incCntSharedPref,
                child: const Icon(Icons.add),
            ),
            const Text(
              'Counter for path provider:',
            ),
            Text(
              '$_cnt_path_prov',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: _incCntPathProv,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
