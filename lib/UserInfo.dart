class UserInfo {
  String? userId;
  String? username;
  String? fullnames;
  String? phoneNumber;
  String? email;

  static final UserInfo _singleton = UserInfo._internal();

  factory UserInfo() {
    return _singleton;
  }

  UserInfo._internal();

  void setUserDetails(String userId, String username, String fullnames, String phoneNumber, String email) {
    this.userId = userId;
    this.username = username;
    this.fullnames = fullnames;
    this.phoneNumber = phoneNumber;
    this.email = email;
  }
}
