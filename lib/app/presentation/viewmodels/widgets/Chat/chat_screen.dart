import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/user_model.dart';
import '../../../provider/chat/chat_room_provider.dart';
import '../../../provider/chat/chat_state_provider.dart';
import 'chat_app_bar.dart';
import 'chat_empty_state.dart';
import 'chat_input_field.dart';
import 'chat_message_list.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final UserModel friendData;
  final String roomId;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.friendData,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController _messageController;
  late final ChatParams _chatParams;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatParams = ChatParams(
      roomId: widget.roomId,
      friendData: widget.friendData,
    );

    // Initialize chat state
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      ref.read(chatStateProvider(_chatParams).notifier).initialize();
    await  ref.read(readMessageProvider(widget.roomId).future);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(getMessagesProvider(widget.roomId));

    // Listen to chat state changes
    ref.listen<ChatState>(
      chatStateProvider(_chatParams),
          (previous, next) {
        _handleStateChanges(previous, next);
      },
    );

    return Scaffold(
      appBar: ChatAppBar(
        friendData: widget.friendData,
        chatParams: _chatParams,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return ChatEmptyState(chatParams: _chatParams);
                  }
                  return ChatMessageList(
                    messages: messages,
                    chatParams: _chatParams,
                  );
                },
                error: (error, stackTrace) => _buildErrorState(error),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            ChatInputField(
              controller: _messageController,
              chatParams: _chatParams,
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(ChatState? previous, ChatState next) {
    // Handle message text changes
    if (previous?.messageText != next.messageText &&
        _messageController.text != next.messageText) {
      _messageController.text = next.messageText;
    }

    // Handle errors
    if (next.error != null && next.error != previous?.error) {
      _showSnackBar(next.error!);
      // Clear error after showing
      Future.microtask(() {
        ref.read(chatStateProvider(_chatParams).notifier).clearError();
      });
    }
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading messages',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(getMessagesProvider(widget.roomId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}