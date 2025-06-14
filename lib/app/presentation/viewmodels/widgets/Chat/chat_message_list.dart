import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/message_model.dart';
import '../../../provider/chat/chat_state_provider.dart';
import 'chat_message_card.dart';

class ChatMessageList extends ConsumerWidget {
  final List<Message> messages;
  final ChatParams chatParams;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.chatParams,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedMessages = List<Message>.from(messages)
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return ListView.builder(
      reverse: true,
      itemCount: sortedMessages.length,
      itemBuilder: (context, index) {
        final message = sortedMessages[index];
        return _ChatMessageItem(
          message: message,
          index: index,
          chatParams: chatParams,
        );
      },
    );
  }
}

class _ChatMessageItem extends ConsumerWidget {
  final Message message;
  final int index;
  final ChatParams chatParams;

  const _ChatMessageItem({
    required this.message,
    required this.index,
    required this.chatParams,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatStateProvider(chatParams));
    final isSelected = chatState.selectedMessageIds.contains(message.id);
    final notifier = ref.read(chatStateProvider(chatParams).notifier);

    return GestureDetector(
      onTap: () => _handleTap(chatState, notifier),
      onLongPress: () => notifier.toggleMessageSelection(message),
      child: ChatMessageCard(
        messageContent: message,
        index: index,
        roomId: chatParams.roomId,
        selected: isSelected,
      ),
    );
  }

  void _handleTap(ChatState chatState, ChatStateNotifier notifier) {
    if (chatState.hasSelectedMessages) {
      notifier.toggleMessageSelection(message);
    }
  }
}
