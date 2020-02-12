class GetAllChallenges {
  int cid;
  String name;
  Loc loc;

  GetAllChallenges({this.cid, this.name, this.loc});

  GetAllChallenges.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    name = json['name'];
    loc = json['loc'] != null ? new Loc.fromJson(json['loc']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['name'] = this.name;
    if (this.loc != null) {
      data['loc'] = this.loc.toJson();
    }
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
