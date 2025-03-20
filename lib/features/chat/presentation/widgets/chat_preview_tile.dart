import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/mock_chats.dart';
import '../screens/chat_screen.dart';
import '../../../profile/presentation/widgets/status_indicator.dart';

class ChatPreviewTile extends StatelessWidget {
  final ChatPreview chat;

  const ChatPreviewTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    ChatScreen(user: chat.user),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      leading: Stack(
        children: [
          Hero(
            tag: 'avatar-${chat.user.id}',
            child: CircleAvatar(
              backgroundImage: NetworkImage(chat.user.avatarUrl),
              radius: 24,
            ),
          ),
          if (chat.user.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: StatusIndicator(isOnline: chat.user.isOnline),
            ),
        ],
      ),
      title: Text(
        chat.user.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormatter.formatLastMessageTime(chat.lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color:
                  chat.unreadCount > 0
                      ? AppColors.primary
                      : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          if (chat.unreadCount > 0)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
