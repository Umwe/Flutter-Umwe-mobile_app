class UserInfo {
  String? userId;
  String? username;

  static final UserInfo _singleton = UserInfo._internal();

  factory UserInfo() {
    return _singleton;
  }

  UserInfo._internal();

  void setUserDetails(String userId, String username) {
    this.userId = userId;
    this.username = username;
  }
}
