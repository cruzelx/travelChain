class GetVideoUrls {
  bool viewed;
  String assignTime;
  String sId;
  int vid;
  String vhash;
  int uid;
  int cid;

  GetVideoUrls(
      {this.viewed,
      this.assignTime,
      this.sId,
      this.vid,
      this.vhash,
      this.uid,
      this.cid});

  GetVideoUrls.fromJson(Map<String, dynamic> json) {
    viewed = json['viewed'];
    assignTime = json['assignTime'];
    sId = json['_id'];
    vid = json['vid'];
    vhash = json['vhash'];
    uid = json['uid'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['viewed'] = this.viewed;
    data['assignTime'] = this.assignTime;
    data['_id'] = this.sId;
    data['vid'] = this.vid;
    data['vhash'] = this.vhash;
    data['uid'] = this.uid;
    data['cid'] = this.cid;
    return data;
  }
}
