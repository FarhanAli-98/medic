// Copyright (c) 2020 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

/// Model calss to store `Address` information of the user.
class Payment {
  Payment({
    this.paymentMethod,
    this.bankName,
    this.fullName,
    this.mobileNo,
    this.accountName,
    this.branch,
    this.routingNum,
    this.bankAccountNo,
  });

  Payment.fromMap(Map<String, dynamic> jsonData) {
    paymentMethod = jsonData['paymentMethod'] ?? '';
    fullName = jsonData['fullName'] ?? '';
    mobileNo = jsonData['mobileNo'] ?? '';
    bankName = jsonData['bankName'] ?? '';
    branch = jsonData['branch'] ?? '';
    accountName = jsonData['accountName'] ?? '';
    routingNum = jsonData['routingNum'] ?? '';
    routingNum = jsonData['bankAccountNo'] ?? '';
  }

  Payment.empty() {
    paymentMethod = '';
    fullName = '';
    mobileNo = '';
    bankName = '';
    branch = '';
    accountName = '';
    routingNum = '';
    bankAccountNo = '';
  }

  String paymentMethod,
      fullName,
      mobileNo,
      bankName,
      branch,
      accountName,
      routingNum,
      bankAccountNo;

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod ?? '',
      'bankName': bankName ?? '',
      'fullName': fullName ?? '',
      'mobileNo': mobileNo ?? '',
      'accountName': accountName ?? '',
      'branch': branch ?? '',
      'routingNum': routingNum ?? '',
      'bankAccountNo': bankAccountNo ?? '',
    };
  }
}
