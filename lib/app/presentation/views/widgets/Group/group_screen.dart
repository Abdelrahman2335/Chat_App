import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/message_constants.dart';
import '../../../../data/models/group_model.dart';
import '../../../../data/models/message_model.dart';
import '../../../../data/repositories/group_room/group_room_repo_impl.dart';
import '../../../provider/group/group_room_provider.dart';
import 'group_member.dart';
import 'group_message_card.dart';

class GroupScreen extends ConsumerStatefulWidget {
  final GroupRoom groupRoom;

  const GroupScreen({super.key, required this.groupRoom});

  @override
  ConsumerState<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: MessageConstants.verticalPaddingHome,
          horizontal: MessageConstants.horizontalPadding,
        ),
        child: Column(
          children: [
            Expanded(child: _buildMessagesList()),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final groupMembers =
        ref.read(getGroupMembersProvider(widget.groupRoom.members));

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.groupRoom.name),
          _buildMembersList(groupMembers),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _navigateToMembers,
          icon: const Icon(Iconsax.user),
        ),
      ],
    );
  }

  Widget _buildMembersList(AsyncValue groupMembers) {
    return groupMembers.when(
      data: (members) => Text(
        members.map((member) => member.name).join(', '),
        style: Theme.of(context).textTheme.labelMedium,
      ),
      error: (_, __) => const Text(MessageConstants.noMembersText),
      loading: () => const SizedBox.shrink(),
    );
  }

  Widget _buildMessagesList() {
    final messages = ref.watch(getGroupMessagesProvider(widget.groupRoom.id));

    return messages.when(
      data: _buildMessagesContent,
      error: (error, stackTrace) {
        log("Error loading messages: $error");
        return const Center(
          child: Text(MessageConstants.errorMessage),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildMessagesContent(List<Message> messages) {
    if (messages.isEmpty) {
      return _buildWelcomeCard();
    }

    final sortedMessages = _sortMessagesByDate(messages);
    log("Message count: ${sortedMessages.length}");

    return ListView.builder(
      reverse: true,
      itemCount: sortedMessages.length,
      itemBuilder: (context, index) => GroupMessageCard(
        message: sortedMessages[index],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Center(
      child: GestureDetector(
        onTap: () => _sendWelcomeMessage(),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(MessageConstants.cardPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  MessageConstants.welcomeEmoji,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  MessageConstants.welcomePrompt,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: MessageConstants.bottomPadding,
      ),
      child: Row(
        children: [
          Expanded(child: _buildMessageTextField()),
          const SizedBox(width: MessageConstants.buttonSpacing),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildMessageTextField() {
    return Card(
      child: TextField(
        controller: _messageController,
        maxLines: MessageConstants.maxMessageLines,
        minLines: MessageConstants.minMessageLines,
        decoration: InputDecoration(
          suffix: _buildTextFieldSuffix(),
          border: InputBorder.none,
          hintText: MessageConstants.messageHint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldSuffix() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _onEmojiPressed,
          icon: const Icon(Icons.emoji_emotions_outlined),
        ),
        IconButton(
          onPressed: _onCameraPressed,
          icon: const Icon(Icons.camera_alt_outlined),
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return IconButton.filled(
      onPressed: _canSendMessage() ? _sendMessage : null,
      icon: const Icon(Iconsax.send_1),
    );
  }

  // Helper methods
  List<Message> _sortMessagesByDate(List<Message> messages) {
    return [...messages]..sort((a, b) =>
        b.createdAt?.compareTo(a.createdAt ?? DateTime.now().toString()) ?? 0);
  }

  bool _canSendMessage() {
    return _messageController.text.trim().isNotEmpty;
  }

  Message _createMessage(String content) {
    return Message(
      receiverId: "",
      senderName: null,
      senderId: null,
      messageContent: content,
      type: "text",
      createdAt: null,
      read: "",
    );
  }

  // Event handlers
  void _navigateToMembers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupMemberScreen(
          chatMembers: widget.groupRoom,
        ),
      ),
    );
  }

  void _sendWelcomeMessage() {
    final message = _createMessage(MessageConstants.welcomeMessage);
    _sendMessageToGroup(message);
  }

  void _sendMessage() {
    if (!_canSendMessage()) return;

    final message = _createMessage(_messageController.text.trim());
    _sendMessageToGroup(message);
    _messageController.clear();
  }

  void _sendMessageToGroup(Message message) {
    ref.read(groupRoomRepoProvider).sendGroupMessage(
          message,
          widget.groupRoom.id,
        );
  }

  void _onEmojiPressed() {
    // TODO: Implement emoji picker
  }

  void _onCameraPressed() {
    // TODO: Implement camera functionality
  }
}
