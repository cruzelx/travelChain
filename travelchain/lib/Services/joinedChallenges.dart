class JoinedChallenge {
  String sId;
  String name;
  int cid;

  JoinedChallenge({this.sId, this.name, this.cid});

  JoinedChallenge.fromJson(Map<String, dynamic> json) {
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