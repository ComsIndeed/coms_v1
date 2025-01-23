import 'package:auth_buttons/auth_buttons.dart';
import 'package:coms/classes/coms/firebase_provider.dart';
import 'package:coms/pages/playgrounds/playgrounds_page.dart';
import 'package:coms/pages/settings/api_key_field.dart';
import 'package:coms/pages/settings/clear_chat_settings_item.dart';
import 'package:coms/pages/settings/clear_widgets_settings_item.dart';
import 'package:coms/pages/settings/json_view_toggle.dart';
import 'package:coms/pages/settings/main_prompt_customization.dart';
import 'package:coms/pages/settings/playgrounds_button.dart';
import 'package:coms/pages/settings/refresh_widgets_button.dart';
import 'package:coms/pages/settings/settings_page_action.dart';
import 'package:coms/pages/settings/terminal.dart';
import 'package:coms/pages/settings/web_searching_toggle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const SettingsPageAction(),
      ),
      body: const Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // TODO : Implement an archive for chat histories and widget lists
              // TODO : Create a file cache view thing for files
              GoogleSignInButton(),
              ApiKeyField(),
              WebSearchingToggle(),
              JsonViewToggle(),
              ClearChatSettingsItem(),
              ClearWidgetsSettingsItem(),
              RefreshWidgetsTile(),
              PlaygroundsButton(),
              Terminal(),
              MainPromptCustomization()
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: firebaseProvider.auth.currentUser == null
          ? GoogleAuthButton(
              themeMode: ThemeMode.dark,
              onPressed: () => firebaseProvider.signInWithGoogle(),
            )
          : TextButton(
              onPressed: firebaseProvider.signOut, child: const Text("Logout")),
    );
  }
}
