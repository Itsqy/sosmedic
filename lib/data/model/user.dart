import 'dart:convert';

class User {
  String? name;
  String? tokenAuth;

  User({this.name, this.tokenAuth});

  @override
  String toString() => 'User(name:$name, token: $tokenAuth)';

  Map<String, dynamic> toMap() {
    return {'name': name, 'token': tokenAuth};
  }

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> map) {
    return User(name: map['name'], tokenAuth: map['token']);
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;

    return other is User && other.name == name && other.tokenAuth == tokenAuth;
  }

  @override
  int get hashcode => Object.hash(name, tokenAuth);
}
