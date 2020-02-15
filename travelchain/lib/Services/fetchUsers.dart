class FetchUser {
  String sId;
  int tokens;
  String name;
  String password;
  String gender;
  bool verifier;
  int uid;
  Loc loc;
  List<JoinedChallenges> joinedChallenges;
  List<CompletedChallenges> completedChallenges;
  List<AssignedVideos> assignedVideos;
  int iV;

  FetchUser(
      {this.sId,
      this.tokens,
      this.name,
      this.password,
      this.gender,
      this.verifier,
      this.uid,
      this.loc,
      this.joinedChallenges,
      this.completedChallenges,
      this.assignedVideos,
      this.iV});

  FetchUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tokens = json['tokens'];
    name = json['name'];
    password = json['password'];
    gender = json['gender'];
    verifier = json['verifier'];
    uid = json['uid'];
    loc = json['loc'] != null ? new Loc.fromJson(json['loc']) : null;
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
    if (json['assignedVideos'] != null) {
      assignedVideos = new List<AssignedVideos>();
      json['assignedVideos'].forEach((v) {
        assignedVideos.add(new AssignedVideos.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['tokens'] = this.tokens;
    data['name'] = this.name;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['verifier'] = this.verifier;
    data['uid'] = this.uid;
    if (this.loc != null) {
      data['loc'] = this.loc.toJson();
    }
    if (this.joinedChallenges != null) {
      data['joinedChallenges'] =
          this.joinedChallenges.map((v) => v.toJson()).toList();
    }
    if (this.completedChallenges != null) {
      data['completedChallenges'] =
          this.completedChallenges.map((v) => v.toJson()).toList();
    }
    if (this.assignedVideos != null) {
      data['assignedVideos'] =
          this.assignedVideos.map((v) => v.toJson()).toList();
    }
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
  String name;
  int cid;

  JoinedChallenges({this.sId, this.name, this.cid});

  JoinedChallenges.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['cid'] = this.cid;
    return data;
  }
}

class CompletedChallenges {
  String sId;
  String name;
  int cid;

  CompletedChallenges({this.sId, this.name, this.cid});

  CompletedChallenges.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['cid'] = this.cid;
    return data;
  }
}

class AssignedVideos {
  bool viewed;
  String sId;
  int vid;
  String vhash;
  int uid;
  int cid;
  String assignTime;

  AssignedVideos(
      {this.viewed,
      this.sId,
      this.vid,
      this.vhash,
      this.uid,
      this.cid,
      this.assignTime});

  AssignedVideos.fromJson(Map<String, dynamic> json) {
    viewed = json['viewed'];
    sId = json['_id'];
    vid = json['vid'];
    vhash = json['vhash'];
    uid = json['uid'];
    cid = json['cid'];
    assignTime = json['assignTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['viewed'] = this.viewed;
    data['_id'] = this.sId;
    data['vid'] = this.vid;
    data['vhash'] = this.vhash;
    data['uid'] = this.uid;
    data['cid'] = this.cid;
    data['assignTime'] = this.assignTime;
    return data;
  }
}
