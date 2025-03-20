import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/media_service.dart';
import '../../models/message_model.dart';
import '../../data/mock_chats.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../../../../widgets/text_input_field.dart';
import '../../../auth/models/user_model.dart';
import 'dart:math' as math;

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MediaService _mediaService = MediaService();
  late List<Message> _messages;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = MockChats.getMessagesForUser(widget.user.id);

    // Simulate the other user typing occasionally
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
            });
          }
        });
      }
    });
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);

        // Handle different attachment options
        if (label == 'Camera') {
          _handleCameraOption();
        } else if (label == 'Photos') {
          _handleGalleryOption();
        } else if (label == 'Files') {
          _handleFileOption();
        } else if (label == 'Location') {
          _handleLocationOption();
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _handleCameraOption() async {
    File? photo = await _mediaService.takePhoto(context: context);
    if (photo != null) {
      print("Camera photo path: ${photo.path}");
      _sendMediaMessage(photo.path, MessageType.image);
    }
  }

  Future<void> _handleGalleryOption() async {
    File? image = await _mediaService.pickImageFromGallery(context: context);
    if (image != null) {
      print("Gallery image path: ${image.path}");
      _sendMediaMessage(image.path, MessageType.image);
    }
  }

  Future<void> _handleFileOption() async {
    File? file = await _mediaService.pickFile(context: context);
    if (file != null) {
      _sendMediaMessage(file.path, MessageType.file);
    }
  }

  Future<void> _handleLocationOption() async {
    Map<String, dynamic>? location = await _mediaService.getCurrentLocation(
      context: context,
    );
    if (location != null) {
      // Format location as a message
      String locationMessage =
          "📍 ${location['address']}\nLatitude: ${location['latitude']}, Longitude: ${location['longitude']}";
      _sendTextMessage(locationMessage);
    }
  }

  void _sendMediaMessage(String path, MessageType type) {
    setState(() {
      _messages.insert(
        0,
        Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'currentUserId',
          receiverId: widget.user.id,
          content: path,
          timestamp: DateTime.now(),
          type: type,
        ),
      );
    });

    _scrollToBottom();
  }

  void _sendTextMessage(String text) {
    setState(() {
      _messages.insert(
        0,
        Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'currentUserId',
          receiverId: widget.user.id,
          content: text,
          timestamp: DateTime.now(),
          type: MessageType.text,
        ),
      );
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _sendTextMessage(_messageController.text);
    _messageController.clear();

    // Simulate the other user typing after a message is sent
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });

        // Simulate a reply after typing
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
              _messages.insert(
                0,
                Message(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  senderId: widget.user.id,
                  receiverId: 'currentUserId',
                  content: _getRandomReply(),
                  timestamp: DateTime.now(),
                ),
              );
            });
          }
        });
      }
    });
  }

  String _getRandomReply() {
    final replies = [
      'That sounds great!',
      'I\'ll get back to you on that.',
      'Thanks for letting me know.',
      'Can we talk about this later?',
      'I appreciate your message!',
      'Let me think about it.',
    ];

    return replies[math.Random().nextInt(replies.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.user.avatarUrl)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    widget.user.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      // Change the color to white regardless of online status
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Call functionality would go here
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Video call functionality would go here
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Menu functionality would go here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return MessageBubble(message: message);
                  },
                ),
                if (_isTyping)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: TypingIndicator(isTyping: true),
                  ),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // Show attachment options
              _showAttachmentOptions();
            },
          ),
          Expanded(
            child: TextInputField(
              controller: _messageController,
              hintText: 'Type a message...',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share Content',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAttachmentOption(Icons.photo, 'Photos', Colors.green),
                    _buildAttachmentOption(
                      Icons.camera_alt,
                      'Camera',
                      Colors.blue,
                    ),
                    _buildAttachmentOption(
                      Icons.insert_drive_file,
                      'Files',
                      Colors.orange,
                    ),
                    _buildAttachmentOption(
                      Icons.location_on,
                      'Location',
                      Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
