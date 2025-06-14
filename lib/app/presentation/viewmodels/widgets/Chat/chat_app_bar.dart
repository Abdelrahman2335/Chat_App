import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/utils/custom_data_time.dart';
import '../../../../data/models/user_model.dart';
import '../../../provider/chat/chat_state_provider.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final UserModel friendData;
  final ChatParams chatParams;

  const ChatAppBar({
    super.key,
    required this.friendData,
    required this.chatParams,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatStateProvider(chatParams));
    final theme = Theme.of(context);

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(friendData.name ?? 'Unknown User'),
          Text(
            CustomDateTime.timeByHour(friendData.lastSeen!).toString(),
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _showFeatureComingSoon(context, 'Video Call'),
          icon: const Icon(Icons.videocam_outlined),
          tooltip: 'Video Call',
        ),
        IconButton(
          onPressed: () => _showFeatureComingSoon(context, 'Voice Call'),
          icon: const Icon(Iconsax.call),
          tooltip: 'Voice Call',
        ),
        if (chatState.hasSelectedMessages) _ChatPopupMenu(chatParams: chatParams),
      ],
    );
  }

  void _showFeatureComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature feature coming soon')),
    );
  }
}

class _ChatPopupMenu extends ConsumerWidget {
  final ChatParams chatParams;

  const _ChatPopupMenu({required this.chatParams});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatStateProvider(chatParams));
    final notifier = ref.read(chatStateProvider(chatParams).notifier);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => _handleMenuSelection(value, notifier),
      itemBuilder: (context) => [
        if (notifier.canDeleteSelectedMessages())
          const PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Delete'),
              dense: true,
            ),
          ),
        if (chatState.hasTextToCopy)
          const PopupMenuItem<String>(
            value: 'copy',
            child: ListTile(
              leading: Icon(Icons.copy_outlined),
              title: Text('Copy'),
              dense: true,
            ),
          ),
      ],
    );
  }

  void _handleMenuSelection(String value, ChatStateNotifier notifier) {
    switch (value) {
      case 'delete':
        notifier.deleteSelectedMessages();
        break;
      case 'copy':
        notifier.copySelectedMessages();
        break;
    }
  }
}

