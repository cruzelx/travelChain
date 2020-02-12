class FetchUser {
  Loc loc;
  int tokens;
  String sId;
  String name;
  String password;
  String gender;
  bool verifier;
  int uid;
  List<JoinedChallenges> joinedChallenges;
  List<CompletedChallenges> completedChallenges;
  List<String> assignedVideos;
  int iV;

  FetchUser(
      {this.loc,
      this.tokens,
      this.sId,
      this.name,
      this.password,
      this.gender,
      this.verifier,
      this.uid,
      this.joinedChallenges,
      this.completedChallenges,
      this.assignedVideos,
      this.iV});

  FetchUser.fromJson(Map<String, dynamic> json) {
    loc = json['loc'] != null ? new Loc.fromJson(json['loc']) : null;
    tokens = json['tokens'];
    sId = json['_id'];
    name = json['name'];
    password = json['password'];
    gender = json['gender'];
    verifier = json['verifier'];
    uid = json['uid'];
    if (json['joinedChallenges'] != null) {
      joinedChallenges = new List<JoinedChallenges>();
      json['joinedChallenges'].forEach((v) {
        joinedChallenges.add(new JoinedChallenges.fromJson(v));
      });
    }
    if (json['completedChallenges'] != null) {
      completedChallenges = new List<CompletedChallenges>();
      json['completedChallenges'].forEach((v) {
        completedChallenges.add(new CompletedChallenges.fromJson(v));
      });
    }
    assignedVideos = json['assignedVideos'].cast<String>();
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loc != null) {
      data['loc'] = this.loc.toJson();
    }
    data['tokens'] = this.tokens;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['verifier'] = this.verifier;
    data['uid'] = this.uid;
    if (this.joinedChallenges != null) {
      data['joinedChallenges'] =
          this.joinedChallenges.map((v) => v.toJson()).toList();
    }
    if (this.completedChallenges != null) {
      data['completedChallenges'] =
          this.completedChallenges.map((v) => v.toJson()).toList();
    }
    data['assignedVideos'] = this.assignedVideos;
    data['__v'] = this.iV;
    return data;
  }
}

class Loc {
  String type;
  List<double> coordinates;

  Loc({this.type, this.coordinates});

  Loc.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class JoinedChallenges {
  String sId;
  int cnumber;
  String name;

  JoinedChallenges({this.sId, this.cnumber, this.name});

  JoinedChallenges.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    cnumber = json['cnumber'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['cnumber'] = this.cnumber;
    data['name'] = this.name;
    return data;
  }
}

class CompletedChallenges {
  String sId;
  int cnumber;
  String name;

  CompletedChallenges({this.sId, this.cnumber, this.name});

  CompletedChallenges.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    cnumber = json['cnumber'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['cnumber'] = this.cnumber;
    data['name'] = this.name;
    return data;
  }
}
