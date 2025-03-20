import '../models/profile_model.dart';

class MockProfile {
  static final Profile currentUserProfile = Profile(
    id: 'current_user',
    name: 'Alex Johnson',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    status: 'Available',
    phone: '+1 (555) 123-4567',
    email: 'alex.johnson@example.com',
    location: 'San Francisco, CA',
    isOnline: true,
  );
}
