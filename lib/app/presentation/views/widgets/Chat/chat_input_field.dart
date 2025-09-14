
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../provider/chat/chat_state_provider.dart';

class ChatInputField extends ConsumerWidget {
  final TextEditingController controller;
  final ChatParams chatParams;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.chatParams,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatStateProvider(chatParams));
    final notifier = ref.read(chatStateProvider(chatParams).notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: TextField(
                controller: controller,
                maxLines: 7,
                minLines: 1,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
                onChanged: notifier.updateMessageText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Message",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _showFeatureComingSoon(context, 'Emoji picker'),
                        icon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      IconButton(
                        onPressed: notifier.sendImage,
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          IconButton.filled(
            onPressed: chatState.isLoading ? null : () {
              notifier.sendTextMessage();
              controller.clear();
            },
            icon: chatState.isLoading
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Iconsax.send_1),
          ),
        ],
      ),
    );
  }

  void _showFeatureComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature feature coming soon')),
    );
  }
}