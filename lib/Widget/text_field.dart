import 'dart:ui';

import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomField extends StatefulWidget {
  final String lable;
  final IconData icon;
  final TextEditingController controller;
  final bool secure;
  final bool isEmail;

  const CustomField({
    super.key,
    required this.lable,
    required this.icon,
    required this.controller,
    this.secure = false,
    this.isEmail = false,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool hidepass = true;

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Color color = isDark ? Colors.white : Colors.black;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.secure ? hidepass : false,
      style: TextStyle(color: color),
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
                  setState(() {
                    hidepass = !hidepass;
                  });
                },
                icon: hidepass
                    ? const Icon(
                        Iconsax.eye,
                      )
                    : const Icon(Iconsax.eye_slash),
                color: color,
              )
            : const SizedBox(),
        labelText: widget.lable,
        labelStyle: Theme.of(context).textTheme.labelLarge,
        prefix: Icon(
          widget.icon,
          color: color,
        ),
      ),
      keyboardType: widget.isEmail ? TextInputType.emailAddress : null,
    );
  }
}
