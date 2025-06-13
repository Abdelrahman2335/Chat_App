import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../provider/ui_state_provider.dart';


class CustomField extends ConsumerStatefulWidget {
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
  ConsumerState<CustomField> createState() => _CustomFieldState();


}

class _CustomFieldState extends ConsumerState<CustomField> {

  @override
  Widget build(BuildContext context, ) {
    final hidePass = ref.watch(hidePassProvider);
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.secure ? hidePass : false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(17),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: myColorScheme.secondary)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: widget.secure
            ? IconButton(
                onPressed: () {
                  ref.read(hidePassProvider.notifier).toggle();
                },
                icon: hidePass
                    ? const Icon(Iconsax.eye)
                    : const Icon(Iconsax.eye_slash),
              )
            : const SizedBox(),
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.labelLarge,
        prefix: Icon(widget.icon),
      ),
      keyboardType: widget.isEmail ? TextInputType.emailAddress : null,
    );
  }
}
