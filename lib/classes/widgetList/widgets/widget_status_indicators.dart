import 'package:flutter/material.dart';

class WidgetStatusIndicators extends StatefulWidget {
  final bool expanded;

  const WidgetStatusIndicators({super.key, this.expanded = false});

  @override
  State<WidgetStatusIndicators> createState() => _WidgetStatusIndicatorsState();
}

class _WidgetStatusIndicatorsState extends State<WidgetStatusIndicators> {
  bool isCloudSynced = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              color: isCloudSynced
                  ? Colors.green.withOpacity(0.56)
                  : Colors.white12,
            )
          ],
        ),
      ],
    );
  }
}
