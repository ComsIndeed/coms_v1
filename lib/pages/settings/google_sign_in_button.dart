import 'package:coms/classes/coms/firebase/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/flat_color_icons.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseProvider>(context);

    return firebaseProvider.auth.currentUser == null
        ? Padding(
            padding: const EdgeInsets.all(32.0),
            child: ElevatedButton(
                onPressed: firebaseProvider.signInWithGoogle,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Iconify(FlatColorIcons.google),
                    SizedBox(
                      width: 12,
                    ),
                    Text("Sign-in with Google")
                  ],
                )),
          )
        : const SizedBox();
  }
}
