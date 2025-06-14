import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../provider/ui_state_provider.dart';


class CustomField extends ConsumerWidget {
  const CustomField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.secure = false,
    this.isEmail = false,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool secure;
  final bool isEmail;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final hidePass = ref.watch(uiStateNotifier).hidePassword;

    return TextFormField(
      controller: controller,
      obscureText: secure ? hidePass : false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(17),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: myColorScheme.secondary)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: secure
            ? IconButton(
          onPressed: () {
            ref.read(uiStateNotifier.notifier).togglePassword();
          },
          icon: hidePass
              ? const Icon(Iconsax.eye)
              : const Icon(Iconsax.eye_slash),
        )
            : const SizedBox(),
        labelText: label,
        labelStyle: Theme
            .of(context)
            .textTheme
            .labelLarge,
        prefix: Icon(icon),
      ),
      keyboardType: isEmail ? TextInputType.emailAddress : null,
    );
  }
}
