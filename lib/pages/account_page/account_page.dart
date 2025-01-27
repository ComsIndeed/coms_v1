import 'package:coms/classes/coms/firebase/firebase_provider.dart';
import 'package:coms/reusables/code_block.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Coms Account",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        actions: [
          IconButton(
              onPressed: firebaseProvider.signOut,
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: firebaseProvider.auth.currentUser != null
                      ? NetworkImage(
                          firebaseProvider.auth.currentUser!.photoURL!)
                      : null,
                ),
              ),
              Text(
                firebaseProvider.auth.currentUser?.displayName ?? "No account",
                style: const TextStyle(fontSize: 24),
              ),
              Text(firebaseProvider.auth.currentUser?.email ?? ""),
              CodeBlock(firebaseProvider.auth.currentUser?.uid ?? "Null"),
            ],
          ),
        ),
      ),
    );
  }
}
