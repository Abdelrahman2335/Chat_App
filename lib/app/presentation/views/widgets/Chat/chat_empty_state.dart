
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../provider/chat/chat_state_provider.dart';

class ChatEmptyState extends ConsumerWidget {
  final ChatParams chatParams;

  const ChatEmptyState({
    super.key,
    required this.chatParams,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final notifier = ref.read(chatStateProvider(chatParams).notifier);

    return Center(
      child: GestureDetector(
        onTap: () => notifier.sendGreetingMessage(),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "👋",
                  style: theme.textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  "Say Assalamu Alaikum",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap to send greeting",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
