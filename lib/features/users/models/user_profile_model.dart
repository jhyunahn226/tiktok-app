class UserProfileModel {
  final String uid;
  final String email;
  final String username;
  final DateTime birthday;
  final String bio;
  final String link;
  final bool hasAvatar;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.birthday,
    required this.bio,
    required this.link,
    required this.hasAvatar,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        username = "",
        birthday = DateTime.now(),
        bio = "",
        link = "",
        hasAvatar = false;

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        username = json["username"],
        birthday = json["birthday"].toDate(),
        bio = json["bio"],
        link = json["link"],
        hasAvatar = json["hasAvatar"];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "username": username,
      "birthday": birthday,
      "bio": bio,
      "link": link,
      "hasAvatar": false,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? username,
    DateTime? birthday,
    String? bio,
    String? link,
    bool? hasAvatar,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      birthday: birthday ?? this.birthday,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      hasAvatar: hasAvatar ?? this.hasAvatar,
    );
  }
}
