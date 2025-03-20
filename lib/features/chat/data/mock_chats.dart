import '../models/message_model.dart';
import '../../auth/models/user_model.dart';

class ChatPreview {
  final User user;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatPreview({
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });
}

class MockChats {
  static final List<ChatPreview> chatPreviews = [
    ChatPreview(
      user: User(
        id: '1',
        name: 'John Doe',
        avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
        isOnline: true,
      ),
      lastMessage: 'Hey, how are you doing?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    ChatPreview(
      user: User(
        id: '2',
        name: 'Jane Smith',
        avatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
        isOnline: false,
      ),
      lastMessage: 'See you tomorrow at the meeting!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
    ),
    ChatPreview(
      user: User(
        id: '3',
        name: 'Mike Johnson',
        avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
        isOnline: true,
      ),
      lastMessage: 'Did you check the latest project updates?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 5,
    ),
    ChatPreview(
      user: User(
        id: '4',
        name: 'Sarah Williams',
        avatarUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
        isOnline: true,
      ),
      lastMessage: 'Thanks for your help!',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
    ),
    ChatPreview(
      user: User(
        id: '5',
        name: 'David Brown',
        avatarUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
        isOnline: false,
      ),
      lastMessage: 'Let\'s catch up this weekend',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
    ),
  ];

  static List<Message> getMessagesForUser(String userId) {
    // This would return messages for a specific chat
    return [];
  }
}
