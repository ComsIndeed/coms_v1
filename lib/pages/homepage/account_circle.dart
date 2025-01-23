import 'package:coms/classes/coms/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountCircle extends StatelessWidget {
  const AccountCircle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        backgroundImage: firebaseProvider.auth.currentUser != null
            ? NetworkImage(firebaseProvider.auth.currentUser!.photoURL!)
            : null,
      ),
    );
  }
}
