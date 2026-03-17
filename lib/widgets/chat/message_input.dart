import 'dart:io';

import 'package:couple_mood_mobile/providers/chat/chat_provider.dart';
import 'package:couple_mood_mobile/utils/upload_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;
  final int conversationId;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSend,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                // TODO: Show attachment options
                _showAttachmentOptions(context);
              },
            ),

            // Text input
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => onSend(),
                ),
              ),
            ),

            // Send button
            IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Share',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Hình ảnh'),
              onTap: () async {
                final chatProvider = context.read<ChatProvider>();
                Navigator.pop(context);
                final picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  final file = File(image.path);
                  final res = await UploadUtil.uploadImage(file);
                  await chatProvider.sendFileMessage(
                    conversationId: conversationId,
                    messageType: 'IMAGE',
                    fileUrl: res,
                    fileName: image.name,
                    fileSize: await file.length(),
                  );
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.video_call_outlined, color: Colors.blue),
              title: const Text('Video'),
              onTap: () async {
                final chatProvider = context.read<ChatProvider>();
                Navigator.pop(context);
                final picker = ImagePicker();
                final XFile? video = await picker.pickVideo(
                  source: ImageSource.gallery,
                );
                if (video != null) {
                  final file = File(video.path);
                  final res = await UploadUtil.uploadImage(file);
                  await chatProvider.sendFileMessage(
                    conversationId: conversationId,
                    messageType: 'VIDEO',
                    fileUrl: res,
                    fileName: video.name,
                    fileSize: await file.length(),
                  );
                }
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: const Text('Location'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement location picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.purple),
              title: const Text('Date Plan'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement date plan picker
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.insert_drive_file,
                color: Colors.orange,
              ),
              title: const Text('File'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement file picker
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
