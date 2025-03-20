import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isSentByCurrentUser;

  MessageBubble({super.key, required this.message, bool? isSentByCurrentUser})
    : isSentByCurrentUser =
          isSentByCurrentUser ?? message.senderId == 'currentUserId';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding:
            message.type == MessageType.image
                ? const EdgeInsets.all(4)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSentByCurrentUser
                  ? AppColors.sentMessage
                  : AppColors.receivedMessage,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildMessageContent(context),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormatter.formatMessageTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isSentByCurrentUser) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color:
                        message.isRead
                            ? AppColors.primary
                            : AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.type) {
      case MessageType.image:
        return _buildImageContent(context);
      case MessageType.file:
        return _buildFileContent();
      case MessageType.audio:
        return _buildAudioContent();
      case MessageType.text:
      default:
        return Text(message.content, style: const TextStyle(fontSize: 16));
    }
  }

  Widget _buildImageContent(BuildContext context) {
    final file = File(message.content);
    print("Attempting to load image from: ${message.content}");

    return GestureDetector(
      onTap: () {
        if (file.existsSync()) {
          _showImagePreview(context, file);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Image file not found')));
        }
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Builder(
            builder: (context) {
              try {
                if (file.existsSync()) {
                  return Image.file(
                    file,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print("Error loading image: $error");
                      return _buildImageErrorWidget();
                    },
                  );
                } else {
                  print("File does not exist: ${file.path}");
                  return _buildImageErrorWidget();
                }
              } catch (e) {
                print("Exception loading image: $e");
                return _buildImageErrorWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageErrorWidget() {
    return Container(
      width: 200,
      height: 200,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.broken_image, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text('Image not available', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _showImagePreview(BuildContext context, File file) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4,
                  child: Image.file(
                    file,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print("Error in preview: $error");
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.white54,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildFileContent() {
    final fileName = message.content.split('/').last;
    final fileExtension = fileName.split('.').last.toLowerCase();

    IconData fileIcon;
    Color iconColor;

    // Determine icon based on file extension
    switch (fileExtension) {
      case 'pdf':
        fileIcon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'doc':
      case 'docx':
        fileIcon = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        fileIcon = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'ppt':
      case 'pptx':
        fileIcon = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case 'zip':
      case 'rar':
        fileIcon = Icons.folder_zip;
        iconColor = Colors.amber;
        break;
      default:
        fileIcon = Icons.insert_drive_file;
        iconColor = Colors.blue;
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(fileIcon, color: iconColor),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to open',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioContent() {
    // This would be implemented with an audio player widget
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.audiotrack, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Audio message',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Icon(Icons.play_arrow, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
