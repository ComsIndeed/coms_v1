import 'package:coms/classes/coms/terminal_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Terminal extends StatefulWidget {
  const Terminal({
    super.key,
  });

  @override
  State<Terminal> createState() => _TerminalState();
}

class _TerminalState extends State<Terminal> {
  int currentPage = 1;
  int historyLength = 0;

  @override
  Widget build(BuildContext context) {
    final terminalProvider = Provider.of<TerminalProvider>(context);
    historyLength = terminalProvider.history.length;

    void moveIndexBy(int numberOfPages) {
      if (numberOfPages < 0 && currentPage != 1) {
        setState(() {
          currentPage = currentPage + numberOfPages;
        });
        return;
      }
      if (numberOfPages > 0 && currentPage < historyLength) {
        setState(() {
          currentPage = currentPage + numberOfPages;
        });
        return;
      }
      Fluttertoast.showToast(msg: "No more pages");
    }

    return ExpansionTile(
      title: const Text("Terminal"),
      subtitle: const Text("Run Javascript and view errors here"),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                color: Colors.blue.shade900,
                height: 160,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(terminalProvider.history.isNotEmpty
                        ? terminalProvider.history.elementAt(currentPage - 1)
                        : "Basic terminal 1.0.0"),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => moveIndexBy(-1),
                      icon: const Icon(Icons.navigate_before)),
                  Text("$currentPage / $historyLength"),
                  IconButton(
                      onPressed: () => moveIndexBy(1),
                      icon: const Icon(Icons.navigate_next)),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          currentPage = 1;
                        });
                        terminalProvider.clear();
                      },
                      child: const Text("Clear"))
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
