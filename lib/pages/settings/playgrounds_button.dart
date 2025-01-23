import 'package:coms/pages/playgrounds/playgrounds_page.dart';
import 'package:flutter/material.dart';

class PlaygroundsButton extends StatelessWidget {
  const PlaygroundsButton({
    super.key,
  });

  void navigateToPlaygrounds(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PlaygroundsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Playgrounds"),
      subtitle: const Text(
          "This page is purely for the dev. There is nothing for you to do here."),
      trailing: IconButton.outlined(
          onPressed: () => navigateToPlaygrounds(context),
          icon: const Icon(Icons.security_rounded)),
    );
  }
}
