import 'package:flutter/material.dart';
import 'package:Notes_App/utils/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog({
  required BuildContext context,
  required Color color,
  required String title,
  required String bcontent,
  required String fcontent,
}) {
  return showGenericDialog<void>(
    icon: Icons.send_rounded,
    context: context,
    color: color,
    fcont: fcontent,
    title: title,
    content: bcontent,
    optionsBuilder: () => {
      fcontent: null,
    },
  );
}
