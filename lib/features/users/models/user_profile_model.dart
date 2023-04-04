class UserProfileModel {
  final String uid;
  final String email;
  final String username;
  final DateTime birthday;
  final String bio;
  final String link;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.birthday,
    required this.bio,
    required this.link,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        username = "",
        birthday = DateTime.now(),
        bio = "",
        link = "";

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": username,
      "birthday": birthday,
      "bio": bio,
      "link": link,
    };
  }
}
