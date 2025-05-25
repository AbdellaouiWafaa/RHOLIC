// user_data.dart
// A simple global user data holder

class UserData {
  static String? username;
  static String? email;
  static String? name;
  static int? userId;

  static void setUserData({required String username, required String email, required String name, required int userId}) {
    UserData.username = username;
    UserData.email = email;
    UserData.name = name;
    UserData.userId = userId;
  }
}
