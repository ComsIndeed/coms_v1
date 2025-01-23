import 'package:coms/classes/gemini/attachment/attachment.dart';
import 'package:flutter/material.dart';

class AttachmentList extends StatelessWidget {
  final List<Attachment> attachments;
  final Function(Attachment) deleteAttachment;
  const AttachmentList({
    required this.deleteAttachment,
    required this.attachments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: attachments
          .map((attachment) => attachment.asWidget(deleteAttachment))
          .toList(),
    );
  }
}
