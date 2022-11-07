import 'package:flutter/material.dart';

showSnackBar(BuildContext context, Widget body) {
  final snackBar = SnackBar(content: body);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
