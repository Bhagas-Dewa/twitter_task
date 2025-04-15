class AppUser {
  final String uid;
  final String name;
  final String username;
  final String profilePicture;
  final String profileBanner;

  AppUser({
    required this.uid,
    required this.name,
    required this.username,
    required this.profilePicture,
    required this.profileBanner,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      username: map['username'],
      profilePicture: map['profilePicture'],
      profileBanner: map['profilrBanner'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'profilePicture': profilePicture,
      'profileBanner': profileBanner,
    };
  }
}
