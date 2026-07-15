import 'package:flutter/material.dart';
import 'package:tedblade_app/theme.dart';

class AiAssistantBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
      bottom: 16.0,
      left: 16.0,
      child: FloatingActionButton.small(
        onPressed: () {
          // TODO: implementare assistente AI
        },
        backgroundColor: AppTheme.colors.accent,
        elevation: 3,
        child: const Icon(
          Icons.auto_awesome_sharp,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
