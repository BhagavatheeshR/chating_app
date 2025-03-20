import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/mock_profile.dart';
import '../../models/profile_model.dart';
import '../widgets/status_indicator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockProfile.currentUserProfile;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(profile),
            const SizedBox(height: 16),
            _buildProfileInfo(profile),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Profile profile) {
    return Container(
      height: 200,
      color: AppColors.primary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profile.avatarUrl),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: StatusIndicator(isOnline: profile.isOnline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              profile.status,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(Profile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildInfoItem(Icons.phone, 'Phone', profile.phone),
          _buildInfoItem(Icons.email, 'Email', profile.email),
          _buildInfoItem(Icons.location_on, 'Location', profile.location),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Edit profile functionality would go here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Edit Profile'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              // Logout functionality would go here
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
