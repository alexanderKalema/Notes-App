import 'package:flutter/material.dart';
import 'package:Notes_App/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
    {required BuildContext context,
    required Color color,
    required String title,
    required String bcontent,
    required String fcontent,
    required String lcontent}) {
  return showGenericDialog<void>(
    icon: Icons.error,
    context: context,
    color: color,
    fcont: fcontent,
    title: title,
    content: bcontent,
    optionsBuilder: () => {fcontent: null, lcontent: null},
  );
}
