import 'package:flutter/material.dart';

class FirebaseUiPage extends StatefulWidget {
  const FirebaseUiPage({super.key});

  @override
  State<FirebaseUiPage> createState() => _FirebaseUiPageState();
}

class _FirebaseUiPageState extends State<FirebaseUiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            PinnedHeaderSliver(
              child: Container(
                child: const Center(
                  child: Text(
                    "Firebase ui page",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
