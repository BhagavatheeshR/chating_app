import 'package:flutter/material.dart';
import '../../data/mock_chats.dart';
import '../widgets/chat_preview_tile.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: MockChats.chatPreviews.length,
      itemBuilder: (context, index) {
        final chat = MockChats.chatPreviews[index];
        return ChatPreviewTile(chat: chat);
      },
    );
  }
}
