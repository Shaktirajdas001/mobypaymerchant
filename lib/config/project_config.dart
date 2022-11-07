class ProjectConfig {
  // final String apiLink =
  //     "https://api2.airapay.my/mobile/api/v1"; //playstore release
  // final String apiLink =
  //     "https://api2.dev.airapay.my/mobile/api/v1"; // Quocent ENV
  // final String apiLink =
  //     "https://api2.stg.airapay.my/mobile/api/v1"; // Mobypay Stging
  final String apiLink =
      "https://api2.mobypay.my/mobile/api/v1"; //Mobypay Production
  // final String apiLink =
  //     "https://ext.uat.alpha.airapay.my/mobile/api/v1"; // Airapay UAT Env
  // final String apiLink =
  //     "https://ext.dev.alpha.airapay.my/mobile/api/v1"; // Airapay Dev Env
  // final String apiLink =
  //     "https://api.staging.alpha.airapay.my/mobile/api/v1"; // Airapay Staging Env
  // final String apiLink = "https://api2.stg.airapay.my/mobile/api/v1";
  final String mobileAppKey = "d3VbpseZ12KMXSZkI6JalJ7sS6ytrXYu";
}

class QrString {
  // static const String prefix = "https://web.dev.alpha.airapay.my/bc?q="; // dev
  //static const String prefix = "https://web.uat.alpha.airapay.my/bc?q="; // uat
  // static const String prefix = "https://www2.airapay.my/bc?q="; // staging
  static const String prefix =
      "https://www2.mobypay.my/bc?q="; // production mobypay
  // static const String prefix =
  //     "https://www2.stg.airapay.my/bc?q="; // production airapay
}

class ApiLinks {
  final String loginApi = ProjectConfig().apiLink + "/merchant_login";
  final String forgotPasswordApi = ProjectConfig().apiLink + "/forgot_password";
  final String billHistoryApi = ProjectConfig().apiLink + "/bill_history";
  final String searchBillApi = ProjectConfig().apiLink + "/search_bill";
  final String syncConfigue = ProjectConfig().apiLink + "/merchant-sys-config";
  final String cancelBillApi = ProjectConfig().apiLink + "/cancel_order";
  final String changepassword =
      ProjectConfig().apiLink + "/merchant_change_password";
  final String merchantDetailsApi =
      ProjectConfig().apiLink + "/merchant_details";
  final String createBillApi = ProjectConfig().apiLink + "/create_bill";
}

class SysConfigVariables {
  int billExpireTimeInSec = 600;
}
