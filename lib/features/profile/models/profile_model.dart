class Profile {
  final String id;
  final String name;
  final String avatarUrl;
  final String status;
  final String phone;
  final String email;
  final String location;
  final bool isOnline;

  Profile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.status,
    required this.phone,
    required this.email,
    required this.location,
    this.isOnline = false,
  });
}
