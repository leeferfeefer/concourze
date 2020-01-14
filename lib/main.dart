import 'dart:convert';
import 'package:concourze/model/pipelines.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concourze',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Concourze'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Pipeline>> _pipelines;

  @override
  void initState() {
    super.initState();
    _pipelines = _getPipelines();
  }

  void getPipelinesButtonPressed() {
    setState(() {
      _pipelines = _getPipelines();
    });
  }

  Future<List<Pipeline>> _getPipelines() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IiIsInR5cCI6IkpXVCJ9.eyJjc3JmIjoiZjk2ZGNjYjY3ZGZlNjU0MTdhYzE5ZjkxZWM5NjkxM2E3Mzc3Zjg3NTIxYTY4ZDllNjVkMzFhMjk1MzRhNGUwYyIsImVtYWlsIjoidGVzdCIsImV4cCI6MTU3OTA0NTk1NCwiaXNfYWRtaW4iOnRydWUsIm5hbWUiOiIiLCJzdWIiOiJDZ1IwWlhOMEVnVnNiMk5oYkEiLCJ0ZWFtcyI6eyJtYWluIjpbIm93bmVyIl19LCJ1c2VyX2lkIjoidGVzdCIsInVzZXJfbmFtZSI6InRlc3QifQ.d1Fc4znBmoylHD65uTA1X1wWSogpGUrtxi7Uad_hkRxOdjU-bBQjCoUqEaxkCUE-u2zZh0GMpnVRZgYBS6t-JBbaJxVM-7znW1PKoaqVoC0AJH6g-MGiS49WbRaYrvHDOjJrQxF-151OJaDE5VNpGOtYITDfl8vy3LeiyJ8AIeZ4PAosafqi-AxD439ccgOc--j2HzHI92Ak7wfUhzGfbxFCL86MtXqqWc24_iGeSPOevlymQnkbdIHBNoqIj08DOLw07uNpG-ERnJfY26Cu7grk-pMMjrPG2SAxMV4avQym_kWLNDsP4OwJYvvaJFU9b2_RAKLs39oKX4EL3hz2F2DpF9F58KouZmnKBFaln-EcvUFDdiz-h2jmFE75Qo02GfQPTAVBOlIZSoGJHqJ_HxdhUc7jOMmWnbnBxUnyG-fLyLQ1ed_X__sLGAnFL3wPwUewJ0TLG1T5CH9jlyP3aqbk-GXfRVTA2m0eMFca3AFpqsEtv0yKDNp2mxyk32jOBb1_xJdXZbHcbWZwy16p7VRC4oWl9qEUuPLMsK77I4huHdhtl2oPMC2D2UxO9LBVRM4xLHYjTI0MZ02uKnddh0rCZpZ9yYnnQpPEFVSOz3ObZDzXAC-wXiqvmzD2QrbdJbQEGFYN1FJdzcx_KZXs9IcWNRJzuoVTYSwpt9-wjhA'
    };

    final response = await http.get('http://localhost:8080/api/v1/pipelines',
        headers: requestHeaders);

    if (response.statusCode == 200) {
      var pipelinesJson = jsonDecode(response.body) as List;
      List<Pipeline> pipelines = pipelinesJson.map((pipelineJson) => Pipeline.fromJson(pipelineJson)).toList();
      return pipelines;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Pipeline>>(
          future: _pipelines,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else {
              final pipelines = snapshot.data ?? <Pipeline>[];

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: pipelines.length,
                itemBuilder: (context, index) {
                  return Card(
                  color: Colors.amber[(6-index)*100],
                  child: InkWell(
                      splashColor: Colors.blue,
                      onTap: () {
                        print('Card tapped.');
                      },
                      child: Center(
                        child: Container(
                          height: 100,
                          child: Text('${pipelines[index].name}',
                          style: TextStyle(fontSize: 30)),
                        ),
                      )
                    ),
                  );
                },
              );
            }
          }
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: getPipelinesButtonPressed,
        tooltip: 'Make call to retrieve pipelines',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
//      body:
//  }
