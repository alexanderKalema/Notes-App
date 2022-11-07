
import 'package:flutter/material.dart';
import 'package:nibret_kifel/utils/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
return showGenericDialog<void>(
  icon: Icons.sentiment_dissatisfied_outlined,
context: context,
title: 'Sharing',
content: 'You cannot share an empty note!',
optionsBuilder: () => {
'OK': null,
},
);
}