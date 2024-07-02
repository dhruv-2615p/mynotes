import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Reset Password',
    content:
        'We had sent password reset link.\nPlease check you email for more info.',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
