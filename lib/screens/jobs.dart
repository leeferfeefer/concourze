import 'dart:convert';
import 'package:concourze/model/job.dart';
import 'package:concourze/model/pipeline.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class Jobs extends StatefulWidget {
  Jobs({Key key, this.selectedPipeline}) : super(key: key);
  final Pipeline selectedPipeline;

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  Future<List<Job>> _jobs;

  @override
  void initState() {
    super.initState();
    _jobs = _getJobs();
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

  void toggleState(bool isPaused) async {
    final token = await _getToken();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token"
    };

    final response = await http.put('http://localhost:8080/api/v1/teams/main/pipelines/${widget.selectedPipeline.name}/${isPaused ? 'unpause' : 'pause'}',
        headers: requestHeaders);

    if (response.statusCode == 200) {

    } else {
      throw Exception('Login with fly to get the latest token');
    }
  }

  Future<List<Job>> _getJobs() async {
    final token = await _getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token"
    };

    final response = await http.get('http://localhost:8080/api/v1/teams/main/pipelines/${widget.selectedPipeline.name}/jobs',
        headers: requestHeaders);

    if (response.statusCode == 200) {
      var jobsJson = jsonDecode(response.body) as List;

      List<Job> jobs = jobsJson
          .map((jobJson) => Job.fromJson(jobJson))
          .toList();

      return jobs;
    } else {
      throw Exception('Login with fly to get the latest token');
    }
  }

  @override
  Widget build(BuildContext context) {

    var _isPaused = widget.selectedPipeline.paused;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedPipeline.name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0),
              child: Row(children: <Widget>[
                Spacer(),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
                  children: <Widget>[
                    RaisedButton.icon(
                      label: _isPaused ? Text("Play") : Text("Pause"),
                      onPressed: () {
                        toggleState(_isPaused);
                      },
                      icon: Image.asset(_isPaused ? 'assets/icons/play.png' : 'assets/icons/pause.png',
                          height: 50,
                          width: 50)
                    ),
                  ],
                ),
                Spacer(),
              ])
            ),
          ),
          Expanded(
            flex: 8,
            child: FutureBuilder<List<Job>>(
              future: _jobs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return new Center(
                    child: new CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return new Text('Error: ${snapshot.error}');
                } else {
                  final jobs = snapshot.data ?? <Job>[];

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      var job = jobs[index];
                      return Card(
                          color: Colors.yellow[(6 - index) * 100],
                          child: InkWell(
                              splashColor: Colors.yellowAccent,
                              onTap: () {
//                                Navigator.push(
//                                    context,
//                                    MaterialPageRoute(builder: (context) => Jobs(selectedPipeline: pipeline))).then((value) {
//                                  setState(() {
//                                    _pipelines = _getPipelines();
//                                  });
//                                });
                              },
                              child: Container(
                                  height: 100,
                                  child: Row(children: <Widget>[
                                    Spacer(),
                                    Text('${job.name}',
                                        style: TextStyle(fontSize: 30)),
                                    Spacer()
                                  ]))));
                    },
                  );
                }
              }),
          )
      ])
    );
  }
}