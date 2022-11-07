import 'package:mobi_pay/Transactions/models/transaction_model.dart';
import 'package:mobi_pay/config/project_config.dart';

class GlobalMethods {
  String timerForTxnExpire(TransactionModel txn, Function _cancelTxn) {
    int timeDiff =
        DateTime.now().difference(DateTime.parse(txn.createdAt)).inSeconds;
    int billExTime = SysConfigVariables().billExpireTimeInSec;
    if (timeDiff > billExTime && txn.status_id == '1') {
      _cancelTxn(txn.billcode);
      return 'Expiring...';
    } else {
      Duration duration = Duration(seconds: (billExTime - timeDiff));
      int mins = duration.inMinutes;
      int secs = duration.inSeconds % 60;
      return mins.toString() + 'm:' + secs.toString() + 's';
    }
  }
}