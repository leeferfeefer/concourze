import 'dart:convert';
import 'package:concourze/model/pipelines.dart';
import 'package:concourze/screens/jobs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class Pipelines extends StatefulWidget {
  Pipelines({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PipelinesState createState() => _PipelinesState();
}

class _PipelinesState extends State<Pipelines> {
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

  Future<String> _getToken() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.get('http://localhost:3333/getToken',
        headers: requestHeaders);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get token');
    }
  }

  Future<List<Pipeline>> _getPipelines() async {
    final token = await _getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token"
    };

    final response = await http.get('http://localhost:8080/api/v1/pipelines',
        headers: requestHeaders);

    if (response.statusCode == 200) {
      var pipelinesJson = jsonDecode(response.body) as List;
      List<Pipeline> pipelines = pipelinesJson
          .map((pipelineJson) => Pipeline.fromJson(pipelineJson))
          .toList();
      return pipelines;
    } else {
      throw Exception('Login with fly to get the latest token');
    }
  }

//  _showPipelineMenu(BuildContext context) {
//    print(context);
//    return () async {
//      String selectedPipelineAction = await showMenu<String>(
//        context: context,
//        position: new RelativeRect.fromLTRB(60.0, 40.0, 100.0, 100.0),
//        items: pipelineActions.map((String pipelineAction) {
//          return new PopupMenuItem<String>(
//            child: new Text(pipelineAction),
//            value: pipelineAction,
//          );
//        }).toList(),
//      );
//      if (selectedPipelineAction != null) {
//        print('selected');
////        setState(() {
////
////        });
//      }
//    };
//  }

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
                  var pipeline = pipelines[index];
                  return Card(
                      color: pipeline.paused
                          ? Colors.red[(6 - index) * 100]
                          : Colors.green[(6 - index) * 100],
                      child: InkWell(
                          splashColor: pipeline.paused
                              ? Colors.redAccent
                              : Colors.greenAccent,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Jobs(selectedPipeline: pipeline))).then((value) {
                                  setState(() {
                                    _pipelines = _getPipelines();
                                  });
                              });
                          },
                          child: Container(
                              height: 100,
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text('${pipeline.name}',
                                    style: TextStyle(fontSize: 30)),
                                Spacer()
                              ]))));
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: getPipelinesButtonPressed,
        tooltip: 'Make call to retrieve pipelines',
        child: Icon(Icons.refresh),
      ),
    );
  }
}