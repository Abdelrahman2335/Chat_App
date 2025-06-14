import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'custom_field.dart'; // Renamed for clarity

class ActionBottom extends StatelessWidget {
  const ActionBottom({
    super.key,
    required this.emailController,
    required this.icon,
    required this.buttonLabel,
    required this.onPressed,
  });

  final TextEditingController emailController;
  final IconData icon;
  final String buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showBottomSheet(context),
      child: Icon(icon),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20).add(
          EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(ctx),
            const SizedBox(height: 10),
            CustomField(
              label: "Email",
              icon: Iconsax.direct,
              controller: emailController,
            ),
            const SizedBox(height: 16),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Enter Friend Email",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          buttonLabel,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
