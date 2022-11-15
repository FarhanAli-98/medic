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

import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/consultationProvider.dart';

@deprecated
abstract class SupportViewModel {
  static ConsultationProvider createInstance() {
    return locator<ConsultationProvider>();
  }

  static void setConsultationFormatType(ConsultationFormatType type) {
    createInstance().setConsultationFormatType = type;
  }

  static ConsultationFormatType getConsultationFormatType() {
    return createInstance().formatType;
  }
}
