class User {
  int? id;

  String? name;
  String? email;
  String? phone;
  String? photo;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photo,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    photo = json['photo'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
    };
  }
}
