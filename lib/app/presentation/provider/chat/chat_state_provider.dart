import 'dart:io';
import 'package:chat_app/app/core/constants/message_constants.dart';
import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import 'chat_room_provider.dart';

// Chat State Class
class ChatState {
  final Set<String> selectedMessageIds;
  final List<String> copiedMessages;
  final Set<String> selectedSenderIds;
  final bool isLoading;
  final String? error;
  final String messageText;

  const ChatState({
    this.selectedMessageIds = const <String>{},
    this.copiedMessages = const <String>[],
    this.selectedSenderIds = const <String>{},
    this.isLoading = false,
    this.error,
    this.messageText = '',
  });

  ChatState copyWith({
    Set<String>? selectedMessageIds,
    List<String>? copiedMessages,
    Set<String>? selectedSenderIds,
    bool? isLoading,
    String? error,
    String? messageText,
  }) {
    return ChatState(
      selectedMessageIds: selectedMessageIds ?? this.selectedMessageIds,
      copiedMessages: copiedMessages ?? this.copiedMessages,
      selectedSenderIds: selectedSenderIds ?? this.selectedSenderIds,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      messageText: messageText ?? this.messageText,
    );
  }

  bool get hasSelectedMessages => selectedMessageIds.isNotEmpty;
  bool get canDeleteMessages => selectedSenderIds.isNotEmpty;
  bool get hasTextToCopy => copiedMessages.isNotEmpty;
}

// Chat State Notifier
class ChatStateNotifier extends StateNotifier<ChatState> {
  ChatStateNotifier(this._ref, this._roomId, this._friendData)
      : super(const ChatState());

  final Ref _ref;
  final String _roomId;
  final UserModel _friendData;

  // Initialize chat
  void initialize() {
    _ref.read(readMessageProvider(_roomId));
  }

  // Message text handling
  void updateMessageText(String text) {
    state = state.copyWith(messageText: text);
  }

  void clearMessageText() {
    state = state.copyWith(messageText: '');
  }

  // Message selection handling
  void toggleMessageSelection(Message message) {
    final messageId = message.id!;
    final senderId = message.senderId!;

    final newSelectedIds = Set<String>.from(state.selectedMessageIds);
    final newSelectedSenders = Set<String>.from(state.selectedSenderIds);
    final newCopiedMessages = List<String>.from(state.copiedMessages);

    if (newSelectedIds.contains(messageId)) {
      // Remove selection
      newSelectedIds.remove(messageId);
      newSelectedSenders.remove(senderId);

      if (message.type == "text") {
        newCopiedMessages.remove(message.messageContent);
      }
    } else {
      // Add selection
      newSelectedIds.add(messageId);
      newSelectedSenders.add(senderId);

      if (message.type == "text") {
        newCopiedMessages.add(message.messageContent);
      }
    }

    state = state.copyWith(
      selectedMessageIds: newSelectedIds,
      selectedSenderIds: newSelectedSenders,
      copiedMessages: newCopiedMessages,
    );
  }

  void clearSelection() {
    state = state.copyWith(
      selectedMessageIds: const <String>{},
      selectedSenderIds: const <String>{},
      copiedMessages: const <String>[],
    );
  }

  // Check if user can delete selected messages
  bool canDeleteSelectedMessages() {
    return !state.selectedSenderIds.contains(_friendData.id);
  }

  // Send text message
  Future<void> sendTextMessage() async {
    final FirebaseService firebaseService = FirebaseService();
    if (state.messageText.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final message = Message(
        receiverId: _friendData.id!,
        senderName: firebaseService.auth.currentUser!.displayName,
        senderId: firebaseService.auth.currentUser!.uid,
        messageContent: state.messageText.trim(),
        type: 'text',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        read: '',
      );

      await _ref.read(sendMessageProvider(message, _roomId).future);
      clearMessageText();
    } catch (e) {
      state = state.copyWith(error: 'Failed to send message: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Send greeting message
  Future<void> sendGreetingMessage() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final message = Message(
        receiverId: _friendData.id!,
        senderName: null,
        senderId: null,
        messageContent: MessageConstants.welcomeMessage,
        type: 'text',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        read: '',
      );

      await _ref.read(sendMessageProvider(message, _roomId).future);
    } catch (e) {
      state = state.copyWith(error: 'Failed to send greeting: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Send image
  Future<void> sendImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        state = state.copyWith(isLoading: true, error: null);

        await _ref.read(
          sendImageProvider(
            File(image.path),
            _roomId,
            null,
            _friendData.id!,
          ).future,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to send image: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Delete selected messages
  Future<void> deleteSelectedMessages() async {
    if (!canDeleteSelectedMessages()) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      _ref.read(
        deleteMessageProvider(_roomId, state.selectedMessageIds.toList()),
      );
      clearSelection();
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete messages: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Copy selected messages
  Future<void> copySelectedMessages() async {
    if (!state.hasTextToCopy) return;

    try {
      await Clipboard.setData(
        ClipboardData(text: state.copiedMessages.join('\n')),
      );
      clearSelection();
    } catch (e) {
      state = state.copyWith(error: 'Failed to copy messages: $e');
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for ChatStateNotifier
final chatStateProvider =
    StateNotifierProvider.family<ChatStateNotifier, ChatState, ChatParams>(
  (ref, params) => ChatStateNotifier(ref, params.roomId, params.friendData),
);

// Parameters class for the provider
class ChatParams {
  final String roomId;
  final UserModel friendData;

  const ChatParams({
    required this.roomId,
    required this.friendData,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatParams &&
        other.roomId == roomId &&
        other.friendData.id == friendData.id;
  }

  @override
  int get hashCode => Object.hash(roomId, friendData.id);
}

// Additional providers for specific functionality
final sortedMessagesProvider =
    Provider.family<List<Message>, String>((ref, roomId) {
  final messages = ref.watch(getMessagesProvider(roomId));
  return messages.when(
    data: (data) {
      final sortedMessages = List<Message>.from(data)
        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return sortedMessages;
    },
    error: (_, __) => <Message>[],
    loading: () => <Message>[],
  );
});

// Provider for checking if a message is selected
final isMessageSelectedProvider =
    Provider.family<bool, MessageSelectionParams>((ref, params) {
  final chatState = ref.watch(chatStateProvider(params.chatParams));
  return chatState.selectedMessageIds.contains(params.messageId);
});

class MessageSelectionParams {
  final ChatParams chatParams;
  final String messageId;

  const MessageSelectionParams({
    required this.chatParams,
    required this.messageId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageSelectionParams &&
        other.chatParams == chatParams &&
        other.messageId == messageId;
  }

  @override
  int get hashCode => Object.hash(chatParams, messageId);
}
