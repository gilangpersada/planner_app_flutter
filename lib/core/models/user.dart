class User {
  final String id;
  final String email;
  final String password;
  final String userName;

  User({
    this.id,
    this.email,
    this.password,
    this.userName,
  });

  toJson() {
    return {
      'email': email,
      'password': password,
      'userName': userName,
    };
  }

  factory User.fromMap(Map userSnapshot, String id) {
    return User(
      id: id ?? '',
      email: userSnapshot['email'] ?? '',
      password: userSnapshot['password'] ?? '',
      userName: userSnapshot['username'] ?? '',
    );
  }
}
