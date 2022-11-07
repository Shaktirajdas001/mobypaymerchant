import 'package:flutter/foundation.dart';

class ConfigModel{
  final int id;
  final String key;
  final String value;
  final String valueBox;
  final String text;

  ConfigModel(@required this.id,@required this.key,@required  this.value, @required this.valueBox,@required this.text);
}