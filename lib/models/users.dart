class Users {
  String? uid;
  String? photoUrl;
  String? name;
  String? status;
  String? email;

  Users({
    this.uid,
    this.photoUrl,
    this.name,
    this.status,
    this.email,
  });

  Users.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    photoUrl = json['photoUrl'];
    name = json['name'];
    status = json['status'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['photoUrl'] = photoUrl;
    data['name'] = name;
    data['status'] = status;
    data['email'] = email;
    return data;
  }

  void add(Users users) {}
}
