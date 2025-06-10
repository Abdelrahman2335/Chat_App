import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/custom_data_time.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data/models/message_model.dart';
import '../../pages/photo_view.dart';
import '../../provider/group/group_room_provider.dart';

class GroupMessageCard extends ConsumerWidget {
  final Message message;
  final int index;
  final List members;

  const GroupMessageCard({
    super.key,
    required this.index,
    required this.message,
    required this.members,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMe = message.fromId == FirebaseService().auth.currentUser!.uid;
    // bool isDark = Provider.of<ProviderApp>(context).themeMode == ThemeMode.dark;
    // Color chatColor = isDark ? Colors.white : Colors.black;
    final groupMembers = ref.watch(getGroupMembersProvider(members));

    return groupMembers.when(data: (value) {
      return value.isNotEmpty
          ? Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                isMe
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Iconsax.message_edit),
                      )
                    : const SizedBox(),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isMe ? 16 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 16),
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !isMe
                              ?

                              /// this is equal to if it's not me
                              Text(
                                  value[index].name!,
                                  style: Theme.of(context).textTheme.labelLarge,
                                )
                              : const SizedBox(),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              message.type == "image"
                                  ? GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PhotoViewScreen(
                                                      image: message.msg!))),
                                      child: CachedNetworkImage(
                                        imageUrl: message.msg!,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                      ),
                                    )
                                  : Text(message.msg!,
                                  style: Theme.of(context).textTheme.labelLarge),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isMe
                                      ? Icon(
                                          Iconsax.tick_circle,
                                          size: 15,
                                          color: message.read == ""
                                              ? Colors.grey
                                              : Colors.blueAccent,
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    CustomDateTime.timeByHour(
                                            message.createdAt!)
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          // TODO: add read status
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     Text(
                          //       CustomDateTime.timeByHour(message.createdAt!)
                          //           .toString(),
                          //       style: Theme.of(context).textTheme.labelSmall,
                          //     ),
                          //     const SizedBox(
                          //       width: 6,
                          //     ),
                          //     isMe
                          //         ? const Icon(
                          //             Iconsax.tick_circle,
                          //             size: 15,
                          //             color: Colors.blueAccent,
                          //           )
                          //         : Container(),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          : Container();
    }, error: (error, stackTrace) {
      log("Error in group message card UI: $error");
      return const Center(
        child: Text("something went wrong"),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
