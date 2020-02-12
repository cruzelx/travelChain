class SignUp {
  String name;
  String password;
  String gender;
  double long;
  double lat;
  bool verifier;

  SignUp(
      {this.name,
      this.password,
      this.gender,
      this.long,
      this.lat,
      this.verifier});

  SignUp.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    password = json['password'];
    gender = json['gender'];
    long = json['long'];
    lat = json['lat'];
    verifier = json['verifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['long'] = this.long;
    data['lat'] = this.lat;
    data['verifier'] = this.verifier;
    return data;
  }
}