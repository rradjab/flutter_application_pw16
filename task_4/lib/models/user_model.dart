class UserModel {
  List<User>? users;
  int? total;
  int? skip;
  int? limit;

  UserModel({this.users, this.total, this.skip, this.limit});

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <User>[];
      json['users'].forEach((v) {
        users!.add(User.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? image;
  String? email;
  User({this.id, this.image, this.lastName, this.firstName, this.email});
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    image = json['image'];
    lastName = json['lastName'];
    firstName = json['firstName'];
  }
}
