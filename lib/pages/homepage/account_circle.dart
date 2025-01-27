import 'package:coms/classes/coms/firebase/firebase_provider.dart';
import 'package:coms/pages/account_page/account_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountCircle extends StatelessWidget {
  const AccountCircle({
    super.key,
  });

  void navigateToAccountPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AccountPage()));
  }

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: firebaseProvider.auth.currentUser != null
          ? IconButton(
              onPressed: () => navigateToAccountPage(context),
              icon: CircleAvatar(
                radius: 16,
                backgroundImage:
                    NetworkImage(firebaseProvider.auth.currentUser!.photoURL!),
              ))
          : const SizedBox(width: 0),
    );
  }
}
