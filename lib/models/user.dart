class User {
  String username;
  String email;
  bool isVerified;
  String mobileNumber;
  List<dynamic> likes;

  User(
      {this.username,
      this.email,
      this.isVerified,
      this.mobileNumber,
      this.likes});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        email: json['email'],
        isVerified: json['isVerified'],
        mobileNumber: json['mobileNumber'],
        likes: json['likes']);
  }
}
