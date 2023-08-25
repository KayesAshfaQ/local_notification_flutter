import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.size,
    required this.title,
    this.onPressed,
    this.icon,
  });

  final Size size;
  final String title;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        minimumSize: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        splashFactory: InkRipple.splashFactory,
      ),
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
