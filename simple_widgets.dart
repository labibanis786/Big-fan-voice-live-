import 'package:flutter/material.dart';

class CenterMessage extends StatelessWidget {
  final String message;
  const CenterMessage(this.message, {super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text(message));
}
