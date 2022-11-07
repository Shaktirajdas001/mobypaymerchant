import 'package:flutter/foundation.dart';

class TransactionModel {
  final String id;
  final String billcode;
  var amount;
  final String timestamp;
  final String time;
  final String date;
  String mReference;
  final String status_id;
  String status_code;
  // final String status_desc;
  final String qr_url;
  final pending_timer;
  final String qrcode_string;
  final String createdAt;

  TransactionModel(
      @required this.id,
      @required this.billcode,
      @required this.amount,
      @required this.timestamp,
      @required this.time,
      @required this.date,
      @required this.mReference,
      @required this.status_id,
      @required this.status_code,
      // @required this.status_desc,
      @required this.qr_url,
      @required this.pending_timer,
      @required this.qrcode_string,
      @required this.createdAt,
      );
}
