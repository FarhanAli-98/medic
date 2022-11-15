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

abstract class EnumStrings {
  /// Strings to convert `Appointment Status` from [strings] to [AppointmentStatusType] enum
  static const SCHEDULED = 'scheduled';
  static const PREVIOUS = 'previous';
  static const CANCELLED = 'cancelled';

  // Communication type
  static const CHAT = 'CHAT';
  static const VIDEO_CALL = 'VIDEO_CALL';
  static const VOICE_CALL = 'VOICE_CALL';

  static const String NOT_DEFINED = 'NOT_DEFINED';
}
