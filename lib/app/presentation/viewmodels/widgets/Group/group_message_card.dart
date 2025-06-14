import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/message_constants.dart';
import '../../../../core/utils/custom_data_time.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../data/models/message_model.dart';
import '../../pages/photo_view.dart';



class GroupMessageCard extends ConsumerWidget {
  final Message message;

  const GroupMessageCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final screenWidth = MediaQuery.sizeOf(context).width;
    final currentUserId = FirebaseService().auth.currentUser?.uid;

    if (currentUserId == null) {
      return const SizedBox.shrink(); // Handle null case gracefully
    }

    final isMe = message.fromId == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMe) _buildEditButton(),
          _buildMessageBubble(context, isMe, screenWidth),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return IconButton(
      onPressed: () {
        // TODO: Implement edit functionality
      },
      icon: const Icon(Iconsax.message_edit),
      tooltip: 'Edit message',
    );
  }

  Widget _buildMessageBubble(BuildContext context, bool isMe, double screenWidth) {

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isMe ? MessageConstants.borderRadius : 0),
          bottomRight: Radius.circular(isMe ? 0 : MessageConstants.borderRadius),
          topLeft: const Radius.circular(MessageConstants.borderRadius),
          topRight: const Radius.circular(MessageConstants.borderRadius),
        ),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth * MessageConstants.messageMaxWidthRatio,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: MessageConstants.verticalPadding,
          horizontal: MessageConstants.cardPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isMe) _buildSenderName(context),
            _buildMessageContent(context),
            const SizedBox(height: MessageConstants.spacing),
            _buildMessageFooter(context, isMe),
          ],
        ),
      ),
    );
  }

  Widget _buildSenderName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        message.senderName ?? 'Unknown',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    final messageType = _getMessageType();

    switch (messageType) {
      case MessageType.image:
        return _buildImageMessage(context);
      case MessageType.text:
      return _buildTextMessage(context);
    }
  }

  Widget _buildImageMessage(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPhotoView(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: message.msg,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(height: 8),
                Text(
                  'Failed to load image',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTextMessage(BuildContext context) {
    return Text(
      message.msg,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildMessageFooter(BuildContext context, bool isMe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMe) _buildReadStatus(),
        const SizedBox(width: 8.0),
        _buildTimestamp(context),
      ],
    );
  }

  Widget _buildReadStatus() {
    final isRead = message.read?.isNotEmpty ?? false;
    return Icon(
      Iconsax.tick_circle,
      size: MessageConstants.iconSize,
      color: isRead ? Colors.blueAccent : Colors.grey,
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    final timestamp = message.createdAt;
    if (timestamp == null) return const SizedBox.shrink();

    return Text(
      CustomDateTime.timeByHour(timestamp).toString(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Colors.grey[600],
      ),
    );
  }

  MessageType _getMessageType() {
    return message.type == "image" ? MessageType.image : MessageType.text;
  }

  void _navigateToPhotoView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewScreen(image: message.msg),
      ),
    );
  }
}