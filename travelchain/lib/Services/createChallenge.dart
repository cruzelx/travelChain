class CreateChallenge {
  int creatoruid;
  String name;
  String description;
  double long;
  double lat;
  double prize;

  CreateChallenge(
      {this.creatoruid,
      this.name,
      this.description,
      this.long,
      this.lat,
      this.prize});

  CreateChallenge.fromJson(Map<String, dynamic> json) {
    creatoruid = json['creatoruid'];
    name = json['name'];
    description = json['description'];
    long = json['long'];
    lat = json['lat'];
    prize = json['prize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creatoruid'] = this.creatoruid;
    data['name'] = this.name;
    data['description'] = this.description;
    data['long'] = this.long;
    data['lat'] = this.lat;
    data['prize'] = this.prize;
    return data;
  }
}
