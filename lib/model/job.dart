class Job {
  int id;
  String name;
  String pipelineName;
  String teamName;
  NextBuild nextBuild;
  FinishedBuild finishedBuild;
  List<Inputs> inputs;
  List<Outputs> outputs;
  List<String> groups;

  Job(
      {this.id,
        this.name,
        this.pipelineName,
        this.teamName,
        this.nextBuild,
        this.finishedBuild,
        this.inputs,
        this.outputs,
        this.groups});

  Job.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pipelineName = json['pipeline_name'];
    teamName = json['team_name'];
    nextBuild = json['next_build'] != null
        ? new NextBuild.fromJson(json['next_build'])
        : null;
    finishedBuild = json['finished_build'] != null
        ? new FinishedBuild.fromJson(json['finished_build'])
        : null;
    if (json['inputs'] != null) {
      inputs = new List<Inputs>();
      json['inputs'].forEach((v) {
        inputs.add(new Inputs.fromJson(v));
      });
    }
    if (json['outputs'] != null) {
      outputs = new List<Outputs>();
      json['outputs'].forEach((v) {
        outputs.add(new Outputs.fromJson(v));
      });
    }
    groups = json['groups'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pipeline_name'] = this.pipelineName;
    data['team_name'] = this.teamName;
    if (this.nextBuild != null) {
      data['next_build'] = this.nextBuild.toJson();
    }
    if (this.finishedBuild != null) {
      data['finished_build'] = this.finishedBuild.toJson();
    }
    if (this.inputs != null) {
      data['inputs'] = this.inputs.map((v) => v.toJson()).toList();
    }
    if (this.outputs != null) {
      data['outputs'] = this.outputs.map((v) => v.toJson()).toList();
    }
    data['groups'] = this.groups;
    return data;
  }
}

class NextBuild {
  int id;
  String teamName;
  String name;
  String status;
  String jobName;
  String apiUrl;
  String pipelineName;
  int startTime;

  NextBuild(
      {this.id,
        this.teamName,
        this.name,
        this.status,
        this.jobName,
        this.apiUrl,
        this.pipelineName,
        this.startTime});

  NextBuild.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    name = json['name'];
    status = json['status'];
    jobName = json['job_name'];
    apiUrl = json['api_url'];
    pipelineName = json['pipeline_name'];
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_name'] = this.teamName;
    data['name'] = this.name;
    data['status'] = this.status;
    data['job_name'] = this.jobName;
    data['api_url'] = this.apiUrl;
    data['pipeline_name'] = this.pipelineName;
    data['start_time'] = this.startTime;
    return data;
  }
}

class FinishedBuild {
  int id;
  String teamName;
  String name;
  String status;
  String jobName;
  String apiUrl;
  String pipelineName;
  int startTime;
  int endTime;

  FinishedBuild(
      {this.id,
        this.teamName,
        this.name,
        this.status,
        this.jobName,
        this.apiUrl,
        this.pipelineName,
        this.startTime,
        this.endTime});

  FinishedBuild.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    name = json['name'];
    status = json['status'];
    jobName = json['job_name'];
    apiUrl = json['api_url'];
    pipelineName = json['pipeline_name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_name'] = this.teamName;
    data['name'] = this.name;
    data['status'] = this.status;
    data['job_name'] = this.jobName;
    data['api_url'] = this.apiUrl;
    data['pipeline_name'] = this.pipelineName;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}

class Inputs {
  String name;
  String resource;
  bool trigger;
  List<String> passed;

  Inputs({this.name, this.resource, this.trigger, this.passed});

  Inputs.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    resource = json['resource'];
    trigger = json['trigger'];
    passed = json['passed']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['resource'] = this.resource;
    data['trigger'] = this.trigger;
    data['passed'] = this.passed;
    return data;
  }
}

class Outputs {
  String name;
  String resource;

  Outputs({this.name, this.resource});

  Outputs.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    resource = json['resource'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['resource'] = this.resource;
    return data;
  }
}