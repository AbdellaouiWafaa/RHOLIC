// user_data.dart
// A simple global user data holder

class UserData {
  static String? username;
  static String? email;
  static String? name;

  static void setUserData({required String username, required String email, required String name}) {
    UserData.username = username;
    UserData.email = email;
    UserData.name = name;
  }
}
