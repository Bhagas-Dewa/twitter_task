class AppUser {
  final String uid;
  final String name;
  final String username;
  final String profilePicture;

  AppUser({
    required this.uid,
    required this.name,
    required this.username,
    required this.profilePicture,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      username: map['username'],
      profilePicture: map['profilePicture'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'profilePicture': profilePicture,
    };
  }
}
