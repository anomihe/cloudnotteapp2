import 'package:flutter/material.dart';

class AddToCallScreen extends StatefulWidget {
  const AddToCallScreen({super.key});

  @override
  State<AddToCallScreen> createState() => _AddToCallScreenState();
}

class _AddToCallScreenState extends State<AddToCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Add participants'),
    );
  }
}
