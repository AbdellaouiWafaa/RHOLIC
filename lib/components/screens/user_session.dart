class UserSession {
  static int? userId; // Store userId here
  // User session data for RHOLIC app
}

class UserData {
  static String? username;
  static String? email;
  static String? name;
  static dynamic userId;

  static void setUserData({
    required String username,
    required String email,
    required String name,
    required dynamic userId,
  }) {
    UserData.username = username;
    UserData.email = email;
    UserData.name = name;
    UserData.userId = userId;
  }
   static bool isOtpEntered = false;
}