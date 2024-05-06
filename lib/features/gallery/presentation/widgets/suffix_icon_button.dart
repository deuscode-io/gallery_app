import 'package:flutter/material.dart';

class SuffixIconButton extends StatelessWidget {
  const SuffixIconButton({super.key, required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      onTap: onTap,
      child: child,
    );
  }
}
