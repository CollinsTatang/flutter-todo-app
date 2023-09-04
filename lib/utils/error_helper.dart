
import 'package:flutter/material.dart';

void showFailureMessage(
    BuildContext context, {
      required String message,
    }) {
  final snackBar = SnackBar(
    content: Text(message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessMessage(BuildContext context, {
  required String message,
}) {
  final snackBar = SnackBar(content: Text(message,
    style: const TextStyle(color: Colors.white),
  ),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}