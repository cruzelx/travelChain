class FetchDescription {
  String sId;
  String name;
  int creatoruid;
  String description;
  Loc loc;
  int cid;
  int tokenprice;
  String startdate;
  String enddate;
  List<JoinedUsers> joinedUsers;
  List<CompletedUsers> completedUsers;
  List<Verifiers> verifiers;
  List<SubmittedVideos> submittedVideos;
  int iV;

  FetchDescription(
      {this.sId,
      this.name,
      this.creatoruid,
      this.description,
      this.loc,
      this.cid,
      this.tokenprice,
      this.startdate,
      this.enddate,
      this.joinedUsers,
      this.completedUsers,
      this.verifiers,
      this.submittedVideos,
      this.iV});

  FetchDescription.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    creatoruid = json['creatoruid'];
    description = json['description'];
    loc = json['loc'] != null ? new Loc.fromJson(json['loc']) : null;
    cid = json['cid'];
    tokenprice = json['tokenprice'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    if (json['joinedUsers'] != null) {
      joinedUsers = new List<JoinedUsers>();
      json['joinedUsers'].forEach((v) {
        joinedUsers.add(new JoinedUsers.fromJson(v));
      });
    }
    if (json['completedUsers'] != null) {
      completedUsers = new List<CompletedUsers>();
      json['completedUsers'].forEach((v) {
        completedUsers.add(new CompletedUsers.fromJson(v));
      });
    }
    if (json['verifiers'] != null) {
      verifiers = new List<Verifiers>();
      json['verifiers'].forEach((v) {
        verifiers.add(new Verifiers.fromJson(v));
      });
    }
    if (json['submittedVideos'] != null) {
      submittedVideos = new List<SubmittedVideos>();
      json['submittedVideos'].forEach((v) {
        submittedVideos.add(new SubmittedVideos.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['creatoruid'] = this.creatoruid;
    data['description'] = this.description;
    if (this.loc != null) {
      data['loc'] = this.loc.toJson();
    }
    data['cid'] = this.cid;
    data['tokenprice'] = this.tokenprice;
    data['startdate'] = this.startdate;
    data['enddate'] = this.enddate;
    if (this.joinedUsers != null) {
      data['joinedUsers'] = this.joinedUsers.map((v) => v.toJson()).toList();
    }
    if (this.completedUsers != null) {
      data['completedUsers'] =
          this.completedUsers.map((v) => v.toJson()).toList();
    }
    if (this.verifiers != null) {
      data['verifiers'] = this.verifiers.map((v) => v.toJson()).toList();
    }
    if (this.submittedVideos != null) {
      data['submittedVideos'] =
          this.submittedVideos.map((v) => v.toJson()).toList();
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

class JoinedUsers {
  String sId;
  int uid;

  JoinedUsers({this.sId, this.uid});

  JoinedUsers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['uid'] = this.uid;
    return data;
  }
}

class CompletedUsers {
  String sId;
  int uid;

  CompletedUsers({this.sId, this.uid});

  CompletedUsers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['uid'] = this.uid;
    return data;
  }
}

class Verifiers {
  String sId;
  int uid;

  Verifiers({this.sId, this.uid});

  Verifiers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['uid'] = this.uid;
    return data;
  }
}

class SubmittedVideos {
  String sId;
  int vid;
  String vhash;
  bool verified;
  int uid;
  String videoURL;
  String created;

  SubmittedVideos(
      {this.sId,
      this.vid,
      this.vhash,
      this.verified,
      this.uid,
      this.videoURL,
      this.created});

  SubmittedVideos.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    vid = json['vid'];
    vhash = json['vhash'];
    verified = json['verified'];
    uid = json['uid'];
    videoURL = json['videoURL'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['vid'] = this.vid;
    data['vhash'] = this.vhash;
    data['verified'] = this.verified;
    data['uid'] = this.uid;
    data['videoURL'] = this.videoURL;
    data['created'] = this.created;
    return data;
  }
}
