class UserProfilesModel {
  UserProfilesModel({
    required this.name,
    required this.image,
    required this.isOnline,
    required this.isAdmin,
  });

  final String name;
  final String image;
  final bool isOnline;
  final bool isAdmin;
}
