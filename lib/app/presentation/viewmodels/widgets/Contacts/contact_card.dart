
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../data/models/user_model.dart';


class ContactCard extends StatelessWidget {
  final UserModel user;

  const ContactCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    bool noImage = user.image!.trim() == "".trim();
    return Card(
      child: ListTile(
        leading: noImage
            ? CircleAvatar(
                child: Text(user.name!.characters.first.toUpperCase()),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(user.image!),
              ),
        title: Text(user.name!),
        subtitle: Text(
          user.about!,
          maxLines: 1,
        ),
        trailing: IconButton(
          onPressed: () {
            //TODo: move this function to ViewModel
          //   List<String> members = [
          //     user.id!,
          //     FirebaseAuth.instance.currentUser!.uid,
          //   ]..sort((a, b) => a.compareTo(b));
          //   if (members !=
          //       FirebaseFirestore.instance.collection("rooms").doc()) {
          //     FireData().createRoom(user.email!).then(
          //           (value) => Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => ChatScreen(
          //                 roomId: members.toString(),
          //                 friendData: user,
          //               ),
          //             ),
          //           ),
          //         );
          //   } else {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ChatScreen(
          //           roomId: members.toString(),
          //           friendData: user,
          //         ),
          //       ),
          //     );
          //   }
          },
          icon: const Icon(Iconsax.message),
        ),
      ),
    );
  }
}
