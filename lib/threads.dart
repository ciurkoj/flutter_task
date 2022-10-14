

import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Threads extends StatefulWidget {
  const Threads({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ThreadsState();
  }
}

class _ThreadsState extends State<Threads> {
  List<Widget> commentWidgets=[];

  @override
  void initState() {
    super.initState();
  }
  Future<Map<String, dynamic>> _parseInBackground() async {
    final p = ReceivePort();
    await Isolate.spawn(_readAndParseJson, p.sendPort);
    await Isolate.spawn(_readAndParseJson, p.sendPort);

    String message = await p.first;
    print(message);
    return await p.first as Map<String, dynamic>;
  }

  Future<List<Widget>> widgets() async {
   await _parseInBackground();

    List<Text> texts = [];
    for (int i = 0; i < 10; i++) {
      texts.add(Text("num: $i"));
    }
    return commentWidgets = texts;
  }
  Future createIsolate() async {
    ReceivePort myReceivePort = ReceivePort();
    ReceivePort myReceivePort1 = ReceivePort();

    Isolate.spawn<SendPort>(heavyComputationTask, myReceivePort.sendPort);
    Isolate.spawn<SendPort>(heavyComputationTask, myReceivePort1.sendPort);

    SendPort mikeSendPort = await myReceivePort.first;
    SendPort mikeSendPort1 = await myReceivePort1.first;

    ReceivePort mikeResponseReceivePort = ReceivePort();
    ReceivePort mikeResponseReceivePort1 = ReceivePort();

    mikeSendPort.send(mikeResponseReceivePort.sendPort);
    mikeSendPort1.send(mikeResponseReceivePort1.sendPort);

    mikeResponseReceivePort.listen((message) {
      setState(() {
        commentWidgets.add(Text(message));
      });
    });
    mikeResponseReceivePort1.listen((message) {
      setState(() {
        commentWidgets.add(Text(message));
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        const Padding(padding: EdgeInsets.only(
            top: 10.00, left: 10.00),
        ),
        Center(child: Text("Test threads here"),),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: commentWidgets ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () async {
                  createIsolate();
                },
                child: const Text("Run threads")),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    commentWidgets = [];
                  });
                },
                child: const Text("Reset"))
          ],
        ),


      ],
    );
  }
}


Future<void> _readAndParseJson(SendPort mySendPort)  async {
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);


  for (int i=0; i<10; i++){
    print("$i.... ${Service.getIsolateID(Isolate.current)}");
    mySendPort.send("message + $i");
    sleep(Duration(milliseconds: Random().nextInt(1000)));
  }
  print("done");
}

void heavyComputationTask(SendPort mySendPort) async {
  ReceivePort mikeReceivePort = ReceivePort();
  mySendPort.send(mikeReceivePort.sendPort);
  final SendPort mikeResponseSendPort = await mikeReceivePort.first;
  for(int i=0; i<10;i++){
    int delay = Random().nextInt(1000);
    mikeResponseSendPort.send("$i. ${Service.getIsolateID(Isolate.current)!.replaceAll("isolates/", "")}: $delay");
    sleep(Duration(milliseconds: delay));
  }
  mikeResponseSendPort.send("done");
}
