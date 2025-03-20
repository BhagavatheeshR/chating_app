import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StatusIndicator extends StatelessWidget {
  final bool isOnline;
  final double size;

  const StatusIndicator({super.key, required this.isOnline, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? AppColors.onlineStatus : AppColors.offlineStatus,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
