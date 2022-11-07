import 'package:flutter/material.dart';
import 'package:mobi_pay/Transactions/models/transaction_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:mobi_pay/config/project_config.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> transactions = [];
  String historyApiStatus = "";
  List<TransactionModel> todayTransactions = [];
  List<TransactionModel> searchTransactions = [];

  String sortBy = 'desc';
  String sortByPeriodic = '';
  String searchKey = '';
  bool searching = false;
  double totalTodaySales = 0;
  String startDateTemp = "Start Date";
  String endDateTemp = "End Date";
  String startDate = "";
  String endDate = "";
  String cancelStatus = "";
  fetchData(id, String token, mid) async {
    if(historyApiStatus != "fetched"){
      historyApiStatus = "fetching";
    }
    notifyListeners();
    final response = await http.post(
      Uri.parse(ApiLinks().billHistoryApi),
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.jsonEncode({
        "token": token,
        "user_id": id,
        "period": sortByPeriodic,
        "start_date_range": startDate,
        "end_date_range": endDate,
        "sort_by": sortBy,
        "merchant_id": mid
      }),
    );

    switch (response.statusCode) {
      case 200:
        var results = JSON.jsonDecode(response.body);
        if (results['status'] == "success") {
          var data = results['bill_details'];
          List<TransactionModel> temp = [];
          data.forEach((item) {
            temp.add(TransactionModel(
              item['id'].toString(),
              item['bill_code'].toString(),
              item['amount'].toString(),
              item['created_at'].toString(),
              item['created_time'].toString(),
              item['created_date'].toString(),
              item['merchant_ref'].toString(),
              item['billing_stage_id'].toString(),
              item['stage_name'].toString(),
              // 'desc',
              item['qr_image'].toString(),
              item['pending_timer'] ?? 0,
              item["qrcode_string"] ?? "",
              item["created_at"] ?? "",
            ));
          });

          transactions = temp;
        }
        break;

      default:
        break;
    }
    historyApiStatus = "fetched";
    notifyListeners();
  }

  searchTransactionFunc(id, String token, mid) async {
    if (searchKey == '') {
      searchTransactions = [];
    } else {
      searching = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(ApiLinks().searchBillApi),
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.jsonEncode({
          "token": token,
          "user_id": id,
          "search": searchKey,
          "merchant_id": mid
        }),
      );
      switch (response.statusCode) {
        case 200:
          var results = JSON.jsonDecode(response.body);
          if (results['status'] == "success") {
            var data = results['search_details'];
            List<TransactionModel> temp = [];

            data.forEach((item) {
              temp.add(TransactionModel(
                item['id'].toString(),
                item['bill_code'].toString(),
                item['amount'].toString(),
                item['created_at'].toString(),
                item['created_time'].toString(),
                item['created_date'].toString(),
                item['merchant_ref'].toString(),
                item['billing_stage_id'].toString(),
                item['stage_name'].toString(),
                // 'desc',
                item['qr_image'].toString(),
                item['pending_timer'] ?? 0,
                item["qrcode_string"] ?? "",
                item["created_at"] ?? "",
              ));
            });
            searchTransactions = temp;
          }
          break;

        default:
          break;
      }
    }
    searching = false;
    notifyListeners();
  }

  fetchTodayData(id, String token, mid) async {
    final response = await http.post(
      Uri.parse(ApiLinks().billHistoryApi),
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.jsonEncode({
        "token": token,
        "user_id": id,
        "period": "today",
        "start_date_range": "",
        "end_date_range": "",
        "sort_by": "",
        "merchant_id": mid
      }),
    );
    switch (response.statusCode) {
      case 200:
        var results = JSON.jsonDecode(response.body);
        if (results['status'] == "success") {
          var data = results['bill_details'];
          List<TransactionModel> temp = [];
          totalTodaySales = 0;
          data.forEach((item) {
            temp.add(TransactionModel(
              item['id'].toString(),
              item['bill_code'].toString(),
              item['amount'].toString(),
              item['created_at'].toString(),
              item['created_time'].toString(),
              item['created_date'].toString(),
              item['merchant_ref'].toString(),
              item['billing_stage_id'].toString(),
              item['stage_name'].toString(),
              // 'desc',
              item['qr_image'].toString(),
              item['pending_timer'] ?? 0,
              item["qrcode_string"] ?? "",
              item["created_at"] ?? "",
            ));
            if (item['stage_name'].toString() == "Successful" &&
                item['amount'] != null) {
              totalTodaySales += double.parse(item['amount'].toString());
            }
          });
          // todayTransactions = temp;
          if (todayTransactions != temp) {
            todayTransactions = temp;
          }
        }
        break;

      default:
        break;
    }
    notifyListeners();
  }

  refreshScreen() {
    List<TransactionModel> txnData =
    todayTransactions.where((element) => element.status_id == '1').toList();
    if (txnData.isNotEmpty) {
      notifyListeners();
    }
  }

  cancelTransaction(String tCodeTemp, String tokenTemp, String userIdTemp,
      String mId, String funcValue) async {
    cancelStatus = "fetching";
    final response = await http.post(
      Uri.parse(ApiLinks().cancelBillApi),
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.jsonEncode(
          {"token": tokenTemp, "bill_code": tCodeTemp, "user_id": userIdTemp}),
    );

    switch (response.statusCode) {
      case 200:
        var results = JSON.jsonDecode(response.body);
        if (results['status'] == "success") {
          cancelStatus = 'success';
        }
        break;
      default:
        break;
    }
    if (funcValue == 'history') {
      await fetchData(userIdTemp, tokenTemp, mId);
    } else if (funcValue == 'search') {
      await searchTransactionFunc(userIdTemp, tokenTemp, mId);
    } else {
      await fetchTodayData(userIdTemp, tokenTemp, mId);
    }
  }

  // changeSorting(String temp){
  //   sortBy = temp;
  //   notifyListeners();
  // }
  setTempDates(String sDate, String eDate) {
    startDateTemp = sDate;
    endDateTemp = eDate;
    notifyListeners();
  }

  setDates(String sDate, String eDate) {
    startDate = sDate;
    endDate = eDate;
    notifyListeners();
  }
}
