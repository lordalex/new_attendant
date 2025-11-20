import 'package:flutter/material.dart';

abstract class FFAppConstants {
  static const String ticketListURL =
      'https://www.knex-app.xyz/api/getTicketList';
  static const String searchURL = 'https://www.knex-app.xyz/api/search';
  static const String createticketURL =
      'https://www.knex-app.xyz/api/createTicketForAttendant';
  static const String settickettoprocessing =
      'https://www.knex-app.xyz/api/setTicketToProcessing';
  static const String setPINtoticket =
      'https://www.knex-app.xyz/api/setPINtoticket';

  /// knex
  static const String baseUrl = 'https://www.knex-app.xyz/api/';
  static const String getUserURL = 'https://www.knex-app.xyz/api/getUser';
  static const String setTicketToParked =
      'https://www.knex-app.xyz/api/ticketToParked';
  static const String setPINtoCompleted =
      'https://www.knex-app.xyz/api/setPINtoCompleted';
  static const String setTipURL = 'https://www.knex-app.xyz/api/setTicketTip';
  static const String getMessagesURL =
      'https://www.knex-app.xyz/api/getMessages';
  static const String postMessage =
      'https://www.knex-app.xyz/api/generateMessageData';
  static const String createcasualTicket =
      'https://www.knex-app.xyz/api/createProvisionalTicket';
  static const String registerphonstaticurl =
      'https://lobby.knex-app.xyz/register-phone';
  static const String setTicketToCancel =
      'https://www.knex-app.xyz/api/setTicketToCancel';
}
