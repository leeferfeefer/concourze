class Pipelines {
  List<Pipeline> pipelines;

  Pipelines({this.pipelines});

  Pipelines.fromJson(Map<String, dynamic> json) {

  }
}

class Pipeline {
  int id;
  String name;
  bool paused;
  bool public;
  List<Groups> groups;
  String teamName;

  Pipeline(
      {this.id,
        this.name,
        this.paused,
        this.public,
        this.groups,
        this.teamName});

  Pipeline.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    paused = json['paused'];
    public = json['public'];
    if (json['groups'] != null) {
      groups = new List<Groups>();
      json['groups'].forEach((v) {
        groups.add(new Groups.fromJson(v));
      });
    }
    teamName = json['team_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['paused'] = this.paused;
    data['public'] = this.public;
    if (this.groups != null) {
      data['groups'] = this.groups.map((v) => v.toJson()).toList();
    }
    data['team_name'] = this.teamName;
    return data;
  }
}

class Groups {
  String name;
  List<String> jobs;

  Groups({this.name, this.jobs});

  Groups.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    jobs = json['jobs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['jobs'] = this.jobs;
    return data;
  }
}